import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

// Post States
class HomePostsLoading extends HomeState {}

class HomePostsLoaded extends HomeState {
  final List<PostModel> posts;
  HomePostsLoaded(this.posts);
}

class HomePostsFailure extends HomeState {
  final String error;
  HomePostsFailure(this.error);
}

// User States
class HomeUserLoading extends HomeState {}

class HomeUserLoaded extends HomeState {
  final UserProfile user;
  HomeUserLoaded(this.user);
}

class HomeUserFailure extends HomeState {
  final String error;
  HomeUserFailure(this.error);
}

// Combined State for UI consumption
class HomeCombinedState {
  final List<PostModel>? posts;
  final bool postsLoading;
  final String? postsError;
  
  final UserProfile? user;
  final bool userLoading;
  final String? userError;

  HomeCombinedState({
    this.posts,
    this.postsLoading = false,
    this.postsError,
    this.user,
    this.userLoading = false,
    this.userError,
  });
}
