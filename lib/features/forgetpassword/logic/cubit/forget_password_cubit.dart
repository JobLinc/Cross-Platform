import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  Future<void> sendResetCode(String email) async {
    emit(ForgetPasswordLoading());

    try {
      await Future.delayed(Duration(seconds: 2));

      // i Will call the repo to send reset code
      emit(CodeSent());
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }

  Future<void> verifyResetCode(String code) async {
    emit(ForgetPasswordLoading());

    try {
      await Future.delayed(Duration(seconds: 2));
      // i Will call the repo to send reset code
      emit(EnteringNewPassword());
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }

  Future<void> resetPassword(String newPassword) async {
    emit(ForgetPasswordLoading());

    try {
      await Future.delayed(Duration(seconds: 2));

      // i Will call the repo to send reset code
      emit(PasswordChanged());
    } catch (e) {
      emit(ForgetPasswordFailure(e.toString()));
    }
  }
}
