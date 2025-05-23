import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/data/services/comment_api_service.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';

class CommentRepo {
  final CommentApiService _commentApiService;

  CommentRepo(this._commentApiService);

  Future<CommentModel> getComment(String postId, String commentId) async {
    return await _commentApiService.getComment(postId, commentId);
  }

  Future<List<CommentModel>> getComments(String postID) async {
    return await _commentApiService.getComments(postID);
  }

  Future<String> addComment(
    String postID, 
    String text, 
    {List<TaggedEntity> taggedUsers = const [], 
    List<TaggedEntity> taggedCompanies = const []}
  ) async {
    return await _commentApiService.addComment(
      postID, 
      text,
      taggedUsers: taggedUsers,
      taggedCompanies: taggedCompanies
    );
  }
  
  Future<void> reactToComment(String commentId, Reactions reaction) async {
    await _commentApiService.reactToComment(commentId, reaction);
  }
}
