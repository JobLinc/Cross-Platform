part of 'change_password_cubit.dart';

abstract class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordSuccess extends ChangePasswordState {}

final class ChangePasswordFailure extends ChangePasswordState {
  String err;
  ChangePasswordFailure(this.err);
}
