import 'package:dio/dio.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';

class CommentApiService {
  final Dio _dio;

  CommentApiService(this._dio);

  Future<void> reactToComment(String commentId, Reactions reaction) async {
    final type = reaction.toString().split('.')[1];
    try {
      final respone = await _dio.post('/comment/$commentId/react',
          data: {'type': '${type[0].toUpperCase()}${type.substring(1)}'});
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<CommentModel> getComment(String postId, String commentId) async {
    try {
      final response = await _dio.get('/comment/$commentId');
      return CommentModel.fromJson(response.data, postId);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<CommentModel>> getComments(String postID) async {
    try {
      final response = await _dio.get('/post/$postID/comments');
      List<CommentModel> comments = [];

      for (Map<String, dynamic> comment in response.data) {
        comments.add(CommentModel.fromJson(comment, postID));
      }

      return comments;
    } on DioException catch (e) {
      print(e.toString());
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> addComment(
    String postID, 
    String text, 
    {List<TaggedEntity> taggedUsers = const [], 
    List<TaggedEntity> taggedCompanies = const []}
  ) async {
    try {
      final Map<String, dynamic> data = {
        'text': text,
      };

      if (taggedUsers.isNotEmpty) {
        data['taggedUsers'] = taggedUsers.map((user) => user.toJson()).toList();
      }

      if (taggedCompanies.isNotEmpty) {
        data['taggedCompanies'] = 
            taggedCompanies.map((company) => company.toJson()).toList();
      }

      final response = await _dio.post('/post/$postID/comment', data: data);
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
