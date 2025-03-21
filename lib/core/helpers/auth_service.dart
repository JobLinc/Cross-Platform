import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class AuthService {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  AuthService(this._storage, this._dio);

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _roleKey = 'role';
  static const _userIdKey = 'userId';

  Future<void> saveAuthInfo({
    required String accessToken,
    required String refreshToken,
    required int role,
    required String userId,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _roleKey, value: role.toString());
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    final String? role = await _storage.read(key: _roleKey);
    final String? userId = await _storage.read(key: _userIdKey);
    final String? accessToken = await _storage.read(key: _accessTokenKey);
    final String? refreshToken = await _storage.read(key: _refreshTokenKey);
    return {
      'role': role,
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken
    };
  }

  Future<String?> getRole() async => await _storage.read(key: _roleKey);

  Future<String?> getUserId() async => await _storage.read(key: _userIdKey);

  Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshTokenKey);

  Future<void> clearUserInfo() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _roleKey);
  }

  Future<bool> refreshToken({String? companyId}) async {
    try {
      final String? refreshToken = await getRefreshToken();
      final String? userId = await getUserId();

      if (refreshToken == null || userId == null) {
        throw Exception('Missing refresh token or user ID');
      }

      final requestBody = {
        'refreshToken': refreshToken,
        'userId': userId,
        'companyId': companyId,
      };

      final response =
          await _dio.post('/auth/refresh-token', data: requestBody);

      if (response.statusCode == 200) {
        final data = response.data;

        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null && newRefreshToken != null) {
          await _storage.write(key: _accessTokenKey, value: newAccessToken);
          await _storage.write(key: _refreshTokenKey, value: newRefreshToken);

          print('Token refreshed successfully');
          return true;
        } else {
          throw Exception('Invalid response data');
        }
      } else {
        throw Exception('Failed to refresh token');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await clearUserInfo();
      }
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }
}
