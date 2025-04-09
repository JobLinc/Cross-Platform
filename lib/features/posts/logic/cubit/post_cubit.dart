import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/connections/data/Repo/UserConnections.dart';
import 'package:joblinc/features/posts/data/repos/comment_repo.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/logic/cubit/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo _postRepo;
  final CommentRepo _commentRepo;
  final UserConnectionsRepository _connectionsRepo;

  PostCubit(this._postRepo, this._commentRepo, this._connectionsRepo)
      : super(PostStateInitial());

  Future<void> likePost(String postID) async {}

  Future<void> commentOnPost(String postID, String text) async {}

  Future<void> connect() async {}
}
