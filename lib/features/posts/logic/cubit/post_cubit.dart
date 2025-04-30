import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/data/repos/comment_repo.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/logic/cubit/post_state.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo _postRepo;
  final CommentRepo _commentRepo;
  final UserConnectionsRepository _connectionsRepo;
  late final String postId;

  PostCubit(this._postRepo, this._commentRepo, this._connectionsRepo)
      : super(PostStateInitial());

  void setPostId(String postId) {
    this.postId = postId;
  }

  void closeComments() {
    emit(PostStateInitial());
  }

  Future<void> savePost() async {
    try {
      await _postRepo.savePost(postId);
      emit(PostStateSuccess('Post saved'));
    } catch (e) {
      emit(PostStateFailure(e.toString()));
    }
  }

  Future<void> unsavePost() async {
    try {
      await _postRepo.unsavePost(postId);
      emit(PostStateSuccess('Post removed from saved'));
    } catch (e) {
      emit(PostStateFailure(e.toString()));
    }
  }

  Future<void> editPost(String? text, List<String>? attachmentsUrls) async {
    try {
      await _postRepo.editPost(postId, text, attachmentsUrls);
      emit(PostStateSuccess('Post edited'));
    } catch (e) {
      emit(PostStateFailure(e.toString()));
    }
  }

  Future<void> deletePost() async {
    try {
      await _postRepo.deletePost(postId);
      emit(PostStateSuccess('Post deleted'));
    } catch (e) {
      emit(PostStateFailure(e.toString()));
    }
  }

  Future<void> reactToPost(Reactions reaction) async {
    try {
      await _postRepo.reactToPost(postId, reaction);
    } catch (e) {
      emit(PostStateFailure(e.toString()));
    }
  }

  Future<void> getComments() async {
    emit(PostStateCommentsLoading());
    try {
      final comments = await _commentRepo.getComments(postId);
      emit(PostStateCommentsLoaded(comments));
    } catch (e) {
      emit(PostStateFailure(e.toString()));
    }
  }
}
