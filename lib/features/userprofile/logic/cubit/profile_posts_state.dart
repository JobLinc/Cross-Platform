import 'package:joblinc/features/posts/data/models/post_model.dart';

abstract class ProfilePostsState {}

class ProfilePostsInitial extends ProfilePostsState {}

class ProfilePostsLoading extends ProfilePostsState {}

class ProfilePostsLoaded extends ProfilePostsState {
  final List<PostModel> posts;

  ProfilePostsLoaded(this.posts);
}

class ProfilePostsError extends ProfilePostsState {
  final String message;

  ProfilePostsError(this.message);
}
