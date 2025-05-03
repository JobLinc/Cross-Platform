import 'package:dio/dio.dart';
import 'package:joblinc/features/notifications/data/models/notification_model.dart';

class NotificationApiService {
  final Dio _dio;
  final String _baseUrl = '/notifications';

  NotificationApiService(this._dio);

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get("$_baseUrl/get");

      if (response.statusCode == 200) {
        if (response.data is List) {
          final List<dynamic> data = response.data;
          print("Notification endpoint response"+response.data);
          return data.map((json) => NotificationModel.fromJson(json)).toList();
        } else if (response.data['notifications'] is List) {
          final List<dynamic> data = response.data['notifications'];
          return data.map((json) => NotificationModel.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Failed to fetch notifications: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  Future<void> markAllAsSeen() async {
    try {
      await _dio.put('$_baseUrl/all/read');
    } catch (e) {
      throw Exception('Failed to mark notifications as seen: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.put('$_baseUrl/solo/read', data: {
        'notificationId': notificationId,
      });
    } on DioError catch (e) {
      if (e.response != null) {
        // Try to extract the error message from the response
        if (e.response?.data != null && e.response?.data['message'] != null) {
          throw Exception(e.response?.data['message']);
        }

        switch (e.response?.statusCode) {
          case 400:
            throw Exception('Invalid notification ID.');
          case 404:
            throw Exception('Notification not found.');
          case 500:
            throw Exception('Internal server error. Please try again later.');
          default:
            throw Exception('Server error (${e.response?.statusCode})');
        }
      }

      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<int> getUnseenCount() async {
    try {
      final response = await _dio.get("$_baseUrl/get");
      if (response.statusCode == 200) {
          final int count = response.data['unseenCount'];
          return count;
        } else {
          return 0;
        }
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }
}
