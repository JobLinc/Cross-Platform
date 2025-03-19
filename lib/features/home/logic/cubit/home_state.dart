part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomePostsLoading extends HomeState {}

final class HomePostsFetched extends HomeState {
  final List<PostModel> posts;
  HomePostsFetched(this.posts);
}

final class HomePostsFailure extends HomeState {
  final String error;
  HomePostsFailure(this.error);
}
