import 'package:dio/dio.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';

bool apiEndPointFunctional=false;

class ChatApiService {
  final Dio _dio;

  ChatApiService(this._dio);

  Future<List<dynamic>> getAllChats() async {
    try {
      final response;
      if (apiEndPointFunctional){
         response = await _dio.get(
          '/chat/get',
        );
        return response.data;
      }
      else {
        return mockChats;
      }
      //print(response.data);
      
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