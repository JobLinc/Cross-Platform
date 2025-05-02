import 'package:joblinc/features/posts/data/models/comment_model.dart';

abstract class PostState {}

final class PostStateInitial extends PostState {}

final class PostStateCommentsLoading extends PostState {}

final class PostStateCommentsLoaded extends PostState {
  final List<CommentModel> comments;
  PostStateCommentsLoaded(this.comments);
}

final class PostStateSuccess extends PostState {
  final String successMessage;
  PostStateSuccess(this.successMessage);
}

final class PostStateFailure extends PostState {
  final String error;
  PostStateFailure(this.error);
}
