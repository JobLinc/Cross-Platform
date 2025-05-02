import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomePostsLoading extends HomeState {}

class HomePostsFailure extends HomeState {
  final String error;
  final List<PostModel>? posts;
  final UserProfile? user;

  HomePostsFailure(this.error, {this.posts, this.user});
}

class HomeLoaded extends HomeState {
  final List<PostModel> posts;
  final UserProfile user;

  HomeLoaded({required this.posts, required this.user});
}
