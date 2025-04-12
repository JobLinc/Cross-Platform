abstract class PostState {}

final class PostStateInitial extends PostState {}

final class PostStateLoading extends PostState {}

final class PostStateSuccess extends PostState {}

final class PostStateFailure extends PostState {
  final String error;
  PostStateFailure(this.error);
}
