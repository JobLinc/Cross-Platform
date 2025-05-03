abstract class FocusPostState {}

class FocusPostInitial extends FocusPostState {}

class FocusPostLoading extends FocusPostState {}

class FocusPostLoaded extends FocusPostState {
  final dynamic post;
  
  FocusPostLoaded(this.post);
}

class FocusPostError extends FocusPostState {
  final String error;
  
  FocusPostError(this.error);
}
