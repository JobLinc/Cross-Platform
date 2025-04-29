import 'package:joblinc/features/notifications/data/models/notification_model.dart';
import 'package:joblinc/features/notifications/data/services/notification_api_service.dart';

class NotificationRepo {
  final NotificationApiService _apiService;

  NotificationRepo(this._apiService);

  Future<List<NotificationModel>> getNotifications() {
    return _apiService.getNotifications();
  }

  Future<void> markAllAsSeen() {
    return _apiService.markAllAsSeen();
  }

  Future<void> markAsRead(String notificationId) {
    return _apiService.markAsRead(notificationId);
  }

  Future<int> getUnseenCount() {
    return _apiService.getUnseenCount();
  }
}
