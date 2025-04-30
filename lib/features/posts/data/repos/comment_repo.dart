import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/data/services/comment_api_service.dart';

class CommentRepo {
  final CommentApiService _commentApiService;

  CommentRepo(this._commentApiService);

  Future<CommentModel> getComment(String postId, String commentId) async {
    return await _commentApiService.getComment(postId, commentId);
  }

  Future<List<CommentModel>> getComments(String postID) async {
    return await _commentApiService.getComments(postID);
  }

  Future<String> addComment(String postID, String text) async {
    return await _commentApiService.addComment(postID, text);
  }
}
