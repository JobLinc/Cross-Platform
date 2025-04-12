import 'package:dio/dio.dart';

class CommentApiService {
  final Dio _dio;

  CommentApiService(this._dio);

  //TODO implement once discussed
  // Future<List<CommentModel>> getComments(String postID,int amount) async {
  // }

  Future<String> addComment(String postID, String text) async {
    try {
      final response = await _dio.post('/post/$postID/comment', data: {
        'text': text,
      });
      return response.data['commentId'];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        return 'unauthorized';
      } else {
        return 'internal Server error';
      }
    } else {
      return 'Network error: ${e.message}';
    }
  }
}
