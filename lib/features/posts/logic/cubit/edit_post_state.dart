abstract class EditPostState {}

class EditPostInitial extends EditPostState {}

class EditPostLoading extends EditPostState {}

class EditPostSuccess extends EditPostState {}

class EditPostFailure extends EditPostState {
  final String error;
  EditPostFailure(this.error);
}
