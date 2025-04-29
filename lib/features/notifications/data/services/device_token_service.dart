import 'dart:io';
import 'package:dio/dio.dart';

class DeviceTokenService {
  final Dio _dio;
  final String _baseUrl = '/device-tokens';

  DeviceTokenService(this._dio);

  Future<void> registerDeviceToken(String token) async {
    try {
      String deviceType = _getDeviceType();

      await _dio.post('$_baseUrl/register', data: {
        'token': token,
        'deviceType': deviceType,
      });

      print('Device token registered successfully');
    } catch (e) {
      print('Failed to register device token: $e');
      // Silently fail, we don't want to disrupt the user experience
    }
  }

  Future<void> unregisterDeviceToken(String token) async {
    try {
      await _dio.post('$_baseUrl/unregister', data: {
        'token': token,
      });

      print('Device token unregistered successfully');
    } catch (e) {
      print('Failed to unregister device token: $e');
    }
  }

  String _getDeviceType() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else {
      return 'web';
    }
  }
}
