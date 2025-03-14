import 'package:dio/dio.dart';
import '../models/chat_model.dart';

class ChatApiService {
  final Dio _dio;

  ChatApiService(this._dio);

  Future<List<dynamic>> getAllChats() async {
    try {
      final response = await _dio.get(
        '/conversation/history',
      );
      //print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        return 'Incorrect credentials';
      } else {
        return 'internal Server error}';
      }
    } else {
      return 'Network error: ${e.message}';
    }
  }
}