import 'package:flutter_bloc/flutter_bloc.dart';
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

  void addNewNotification(NotificationModel notification) {
    if (state is NotificationLoaded) {
      final currentNotifications = (state as NotificationLoaded).notifications;

      // Check if this notification already exists
      bool exists = currentNotifications.any((n) => n.id == notification.id);

      if (!exists) {
        // Add to the beginning of the list
        emit(NotificationLoaded([notification, ...currentNotifications]));
      }
    } else if (state is NotificationInitial || state is NotificationError) {
      emit(NotificationLoaded([notification]));
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
    await _socketService.connect();
  }

  void disposeSocket() {
    _socketService.disconnect();
  }

  @override
  Future<void> close() {
    disposeSocket();
    return super.close();
  }
}
