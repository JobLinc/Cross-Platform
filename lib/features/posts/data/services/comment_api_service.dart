import 'package:dio/dio.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';

class CommentApiService {
  final Dio _dio;

  CommentApiService(this._dio);

  Future<List<CommentModel>> getComments(String postID) async {
    try {
      final response = await _dio.get('/post/$postID/comments');
      List<CommentModel> comments = [];

      for (Map<String, dynamic> comment in response.data) {
        comments.add(CommentModel.fromJson(comment, postID));
      }

      return comments;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

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
