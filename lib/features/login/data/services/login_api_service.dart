import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joblinc/features/login/data/models/login_response_model.dart';

class LoginApiService {
  final Dio _dio;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  LoginApiService(this._dio);

  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Handle error response
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Login failed';
        throw message;
      }
      throw 'Connection error. Please check your internet connection.';
    }
  }

  Future<LoginResponseModel> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'Sign-in cancelled';
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw 'Failed to retrieve ID token from Google';

      final response = await _dio.post(
        '/auth/google-login',
        data: {'credential': idToken},
      );
      print("response $response");
      print("response.data ${response.data}");
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Google login failed';
        throw message;
      }
      throw 'Network error during Google login';
    } catch (e) {
      throw e.toString();
    }
  }
}
