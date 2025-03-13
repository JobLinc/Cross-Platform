import 'package:joblinc/features/login/data/models/login_response.dart';

abstract class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginLoading extends LoginState {}
final class LoginSuccess extends LoginState {
}
final class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

