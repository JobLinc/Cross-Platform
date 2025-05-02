import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DeviceTokenService {
  final Dio _dio;

  DeviceTokenService(this._dio);

  /// Registers FCM token with the server
  /// Endpoint: POST /api/auth/register-fcm-token
  Future<void> registerDeviceToken(String token) async {
    try {
      await _dio.post('/auth/register-fcm-token', data: {
        'fcmToken': token,
      });

      debugPrint('FCM token registered successfully');
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
      // Silently fail, we don't want to disrupt the user experience
    }
  }

  /// Removes FCM token from the server
  /// Endpoint: POST /api/auth/remove-fcm-token
  Future<void> unregisterDeviceToken(String token) async {
    try {
      await _dio.post('/auth/remove-fcm-token', data: {
        'fcmToken': token,
      });

      debugPrint('FCM token unregistered successfully');
    } catch (e) {
      debugPrint('Failed to unregister FCM token: $e');
    }
  }
}
