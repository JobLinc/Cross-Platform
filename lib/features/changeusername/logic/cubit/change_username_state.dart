part of 'change_username_cubit.dart';

abstract class ChangeUsernameState {}

class ChangeUsernameInitial extends ChangeUsernameState {}

class ChangeUsernameLoading extends ChangeUsernameState {}

class ChangeUsernameSuccess extends ChangeUsernameState {}

class ChangeUsernameFailure extends ChangeUsernameState {
  final String error;

  ChangeUsernameFailure(this.error);
}
