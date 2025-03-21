abstract class AddPostState {}

final class AddPostStateInitial extends AddPostState {}

final class AddPostStateLoading extends AddPostState {}

final class AddPostStateSuccess extends AddPostState {}

final class AddPostStateFailure extends AddPostState {
  final String error;
  AddPostStateFailure(this.error);
}
