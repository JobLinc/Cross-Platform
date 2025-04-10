import 'package:joblinc/features/posts/data/services/comment_api_service.dart';

class CommentRepo {
  final CommentApiService _commentApiService;

  CommentRepo(this._commentApiService);

  Future<String> addComment(String postID, String text) async {
    return await _commentApiService.addComment(postID, text);
  }
}
