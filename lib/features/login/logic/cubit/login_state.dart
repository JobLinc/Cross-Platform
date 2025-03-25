abstract class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final bool confirmed;
  final String email;

  LoginSuccess({required this.confirmed, required this.email});
}

final class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
