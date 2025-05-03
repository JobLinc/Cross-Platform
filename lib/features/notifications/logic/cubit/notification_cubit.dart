import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/notifications/data/models/notification_model.dart';
import 'package:joblinc/features/notifications/data/repos/notification_repo.dart';
import 'package:joblinc/features/notifications/data/services/device_token_service.dart';
import 'package:joblinc/features/notifications/data/services/firebase_messaging_service.dart';
import 'package:joblinc/features/notifications/data/services/socket_service.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _repo;
  late SocketService _socketService;

  // Don't require FCM service in constructor
  late FirebaseMessagingService _fcmService;
  final String _socketUrl;
  final DeviceTokenService _deviceTokenService;
  bool _closed = false;

  NotificationCubit(
    this._repo,
    this._socketUrl,
    this._deviceTokenService,
  ) : super(NotificationInitial()) {
    _socketService = SocketService(
      baseUrl: _socketUrl,
      onNewNotification: addNewNotification,
    );
  }

  Future<void> initServices() async {
    // Create FCM service with callback to this cubit
    _fcmService = FirebaseMessagingService(
      _deviceTokenService,
      addNewNotification,
    );

    // Initialize Firebase Messaging
    await _fcmService.initialize();

    // Initialize Socket.IO connection
    await _socketService.connect();
  }

  Future<void> getNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await _repo.getNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void markAllAsSeen() async {
    try {
      await _repo.markAllAsSeen();

      // Update the state to reflect that all notifications are now seen
      if (state is NotificationLoaded) {
        final notifications = (state as NotificationLoaded).notifications;
        final updatedNotifications = notifications.map((notification) {
          return NotificationModel(
            id: notification.id,
            type: notification.type,
            content: notification.content,
            imageUrl: notification.imageUrl,
            isRead: "seen",
            createdAt: notification.createdAt,
          );
        }).toList();

        emit(NotificationLoaded(updatedNotifications));
      }
    } catch (e) {
      // Don't emit error, just log it
      print('Error marking notifications as seen: $e');
    }
  }

  void markAsRead(String notificationId) async {
    try {
      await _repo.markAsRead(notificationId);

      // Update the state to reflect that the notification is now read
      if (state is NotificationLoaded) {
        final notifications = (state as NotificationLoaded).notifications;
        final updatedNotifications = notifications.map((notification) {
          if (notification.id == notificationId) {
            return NotificationModel(
              id: notification.id,
              type: notification.type,
              content: notification.content,
              imageUrl: notification.imageUrl,
              isRead: "seen",
              createdAt: notification.createdAt,
            );
          }
          return notification;
        }).toList();

        emit(NotificationLoaded(updatedNotifications));
      }
    } catch (e) {
      // Don't emit error, just log it
      print('Error marking notification as read: $e');
    }
  }

  // This is the main method that handles incoming socket notifications
  void addNewNotification(NotificationModel notification) {
    // Check if cubit is already closed before emitting a new state
    if (_closed) {
      debugPrint('NotificationCubit: Ignoring notification - Cubit is closed');
      return;
    }

    try {
      debugPrint(
          'NotificationCubit: Processing notification: ${notification.id} - ${notification.content}');

      if (state is NotificationLoaded) {
        final currentNotifications =
            (state as NotificationLoaded).notifications;

        // Check if this notification already exists by ID
        bool exists = currentNotifications.any((n) => n.id == notification.id);

        debugPrint('NotificationCubit: Notification exists? $exists');

        if (!exists) {
          // Force notification to "pending" status for new notifications
          if (notification.isRead != "pending") {
            notification = NotificationModel(
              id: notification.id,
              type: notification.type,
              content: notification.content,
              imageUrl: notification.imageUrl,
              isRead: "pending",
              createdAt: notification.createdAt,
              relatedEntityId: notification.relatedEntityId,
              subRelatedEntityId: notification.subRelatedEntityId,
            );
          }

          final updatedNotifications = [notification, ...currentNotifications];
          debugPrint(
              'NotificationCubit: Emitting new state with ${updatedNotifications.length} notifications');
          emit(NotificationLoaded(updatedNotifications));

          // Verify state was updated
          if (state is NotificationLoaded) {
            debugPrint(
                'NotificationCubit: New state has ${(state as NotificationLoaded).notifications.length} notifications');
          }

          // Refresh unseen count
          getUnseenCount();
        } else {
          debugPrint('NotificationCubit: Skipping duplicate notification');
        }
      } else if (state is NotificationInitial || state is NotificationError) {
        debugPrint('NotificationCubit: First notification, creating new list');
        emit(NotificationLoaded([notification]));
      } else {
        debugPrint('NotificationCubit: Unexpected state: ${state.runtimeType}');
      }
    } catch (e) {
      debugPrint('NotificationCubit: Error handling notification: $e');
    }
  }

  Future<int> getUnseenCount() async {
    try {
      return await _repo.getUnseenCount();
    } catch (e) {
      print('Error getting unseen count: $e');
      return 0;
    }
  }

  void initSocket() async {
    debugPrint('NotificationCubit: Initializing socket connection');
    await _socketService.connect();
  }

  void disposeSocket() {
    try {
      _socketService.disconnect();
    } catch (e) {
      debugPrint('NotificationCubit: Error disconnecting socket: $e');
    }
  }

  // Add this method to access the messaging service
  FirebaseMessagingService? getMessagingService() {
    if (_closed) return null;
    return _fcmService;
  }

  @override
  Future<void> close() {
    debugPrint('NotificationCubit: Closing cubit');
    _closed = true;
    disposeSocket();
    return super.close();
  }
}
