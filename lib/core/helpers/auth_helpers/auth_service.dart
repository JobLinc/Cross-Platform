import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class AuthService {
  final FlutterSecureStorage _storage;
  final Dio _dio;
  bool isLoggedInUser = false;

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _roleKey = 'role';
  static const _userIdKey = 'userId';
  static const _emailKey = 'email';
  static const _confirmedKey = 'confirmed';

  AuthService(this._storage, this._dio);

  Future<void> saveAuthInfo({
    required String accessToken,
    required String refreshToken,
    required int role,
    required String userId,
    required String email,
    required bool confirmed,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _roleKey, value: role.toString());
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _confirmedKey, value: confirmed.toString());
    // Update global login status
    isLoggedInUser = true;
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    // Update global login status
    isLoggedInUser = true;
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    final String? role = await _storage.read(key: _roleKey);
    final String? userId = await _storage.read(key: _userIdKey);
    final String? accessToken = await _storage.read(key: _accessTokenKey);
    final String? refreshToken = await _storage.read(key: _refreshTokenKey);
    final String? email = await _storage.read(key: _emailKey);
    final String? confirmed = await _storage.read(key: _confirmedKey);
    return {
      'role': role,
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'email': email,
      'confirmed': confirmed
    };
  }

  Future<String?> getRole() async => await _storage.read(key: _roleKey);

  Future<String?> getUserId() async => await _storage.read(key: _userIdKey);

  Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshTokenKey);

  Future<String?> getEmail() async => await _storage.read(key: _emailKey);

  Future<bool> getConfirmationStatus() async {
    final confirmedString = await _storage.read(key: _confirmedKey);
    return confirmedString != null
        ? confirmedString.toLowerCase() == 'true'
        : false;
  }

  Future<void> clearUserInfo() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _roleKey);
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _confirmedKey);
    isLoggedInUser = false;
  }

  Future<void> updateEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  Future<void> updateConfirmationStatus(bool confirmed) async {
    await _storage.write(key: _confirmedKey, value: confirmed.toString());
  }

  Future<bool> refreshToken({String? companyId}) async {
    try {
      final String? refreshToken = await getRefreshToken();
      final String? userId = await getUserId();

      if (refreshToken == null || userId == null) {
        return false;
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
        await clearUserInfo();
        throw Exception('Session ended please login again');
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

  Future<void> checkIfLoggedInUser() async {
    final accessToken = await getAccessToken();
    final refToken = await getRefreshToken();

    if (accessToken == null || refToken == null) {
      isLoggedInUser = false;
    }
    isLoggedInUser = await refreshToken();
  }

  /// Deletes the user's account
  /// 
  /// Requires the user's password for verification
  /// Returns a response with success (true/false) and a message
  Future<Map<String, dynamic>> deleteAccount(String password) async {
    try {
      final String? accessToken = await getAccessToken();
      
      if (accessToken == null) {
        return {
          'success': false,
          'message': 'You are not logged in. Please log in to delete your account.'
        };
      }
      
      final response = await _dio.delete(
        '/user/me',
        data: {'password': password},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      
      if (response.statusCode == 200) {
        // Clear user data on successful deletion
        await clearUserInfo();
        return {
          'success': true,
          'message': response.data['message'] ?? 'Account successfully deleted'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to delete account. Please try again later.'
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to delete account';
      
      if (e.response?.statusCode == 401) {
        errorMessage = 'Incorrect password or unauthorized access';
      } else if (e.response?.statusCode == 403) {
        errorMessage = 'You do not have permission to delete this account';
      } else if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      
      return {
        'success': false,
        'message': errorMessage
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e'
      };
    }
  }
}
