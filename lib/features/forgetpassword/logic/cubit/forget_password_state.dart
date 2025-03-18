part of 'forget_password_cubit.dart';

abstract class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

final class ForgetPasswordLoading extends ForgetPasswordState {}

final class EnteringCode extends ForgetPasswordState {}

final class CodeSent extends ForgetPasswordState {}

final class CodeResending extends ForgetPasswordState {}

final class EnteringNewPassword extends ForgetPasswordState {}

final class PasswordChanged extends ForgetPasswordState {}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String error;
  ForgetPasswordFailure(this.error);
}

final class ForgetPasswordSuccess extends ForgetPasswordState {}
