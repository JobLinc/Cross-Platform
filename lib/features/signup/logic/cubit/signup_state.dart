part of 'signup_cubit.dart';

sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final bool confirmed;
  final String email;

  RegisterSuccess({required this.confirmed, required this.email});
}

final class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}
