import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/notifications/data/models/notification_model.dart';
import 'package:joblinc/features/notifications/data/repos/notification_repo.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo _repo;
  late IO.Socket _socket;
  // final String _socketUrl =
  //     'https://api.joblinc.com'; // Replace with your actual socket URL

  NotificationCubit(this._repo) : super(NotificationInitial());

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

  void initSocket() async {
    final AuthService authService = getIt<AuthService>();
    final String? token = await authService.getAccessToken();

    if (token == null) {
      print('Cannot initialize socket: No authentication token');
      return;
    }

    // _socket = IO.io(
    //   _socketUrl,
    //   IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
    //       {'Authorization': 'Bearer $token'}).build(),
    // );

    // _socket.connect();

    // _socket.onConnect((_) {
    //   print('Notification socket connected ✅');
    // });

    // _socket.on('newNotification', (data) {
    //   try {
    //     final newNotification = NotificationModel.fromJson(data);

    //     if (state is NotificationLoaded) {
    //       final currentNotifications =
    //           (state as NotificationLoaded).notifications;
    //       emit(NotificationLoaded([...currentNotifications, newNotification]));
    //     } else {
    //       emit(NotificationLoaded([newNotification]));
    //     }
    //   } catch (e) {
    //     print('Error processing new notification: $e');
    //   }
    // });

    // _socket.onDisconnect((_) => print('Notification socket disconnected ❌'));
    // _socket.onError((data) => print('Notification socket error: $data'));
  }

  void disposeSocket() {
    if (_socket.connected) {
      _socket.disconnect();
      _socket.dispose();
    }
  }

  @override
  Future<void> close() {
    disposeSocket();
    return super.close();
  }
}
