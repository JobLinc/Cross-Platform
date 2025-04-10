import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/forgetpassword/data/repos/forgetpassword_repo.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgetPasswordRepo repository;

  ForgetPasswordCubit({required this.repository})
      : super(ForgotPasswordInitial());

  Future<void> sendEmail(String email) async {
    emit(ForgotPasswordLoading());
    try {
      final forgotToken = await repository.forgotPassword(email);
      emit(ForgotPasswordEmailSent(forgotToken));
    } catch (e) {
      // Clean error message
      final errorMessage = e.toString().startsWith('Exception: ')
          ? e.toString().substring('Exception: '.length)
          : e.toString();

      emit(ForgotPasswordError(errorMessage));
    }
  }

  Future<void> verifyOtp(String email, String forgotToken, String otp) async {
    emit(ForgotPasswordLoading());
    try {
      final resetToken = await repository.confirmOtp(
        email: email,
        forgotToken: forgotToken,
        otp: otp,
      );
      emit(ForgotPasswordOtpVerified(resetToken));
    } catch (e) {
      // Clean error message
      final errorMessage = e.toString().startsWith('Exception: ')
          ? e.toString().substring('Exception: '.length)
          : e.toString();

      emit(ForgotPasswordError(errorMessage));
    }
  }

  Future<void> resetPassword(
      String email, String newPassword, String resetToken) async {
    emit(ForgotPasswordLoading());
    try {
      final userData = await repository.resetPassword(
        email: email,
        newPassword: newPassword,
        resetToken: resetToken,
      );
      emit(ForgotPasswordSuccess());
    } catch (e) {
      // Clean error message
      final errorMessage = e.toString().startsWith('Exception: ')
          ? e.toString().substring('Exception: '.length)
          : e.toString();

      emit(ForgotPasswordError(errorMessage));
    }
  }
}
