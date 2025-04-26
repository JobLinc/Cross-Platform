import 'package:joblinc/features/notifications/data/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationLoaded(this.notifications);

  int get unreadCount => notifications.where((n) => n.isRead == "pending").length;
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
