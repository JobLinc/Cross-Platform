abstract class ChangeEmailState {}

class ChangeEmailInitial extends ChangeEmailState {}

class ChangeEmailLoading extends ChangeEmailState {}

class ChangeEmailSuccess extends ChangeEmailState {
  final String message;

  ChangeEmailSuccess(this.message);
}

class ChangeEmailFailure extends ChangeEmailState {
  final String error;

  ChangeEmailFailure(this.error);
}
