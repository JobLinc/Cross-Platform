part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomePostsLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final UserProfile user;
  final List<PostModel> posts;
  HomeLoaded({required this.posts, required this.user});
}

final class HomePostsFailure extends HomeState {
  final String error;
  HomePostsFailure(this.error);
}
