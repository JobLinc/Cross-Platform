import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/emailconfirmation/data/repos/email_confirmation_repo.dart';
import 'package:joblinc/features/emailconfirmation/logic/cubit/email_confirmation_state.dart';

class EmailConfirmationCubit extends Cubit<EmailConfirmationState> {
  final EmailConfirmationRepo _repo;
  String? _verificationToken;

  EmailConfirmationCubit(this._repo) : super(EmailConfirmationInitial());

  Future<void> resendConfirmationEmail(String email) async {
    emit(EmailConfirmationLoading());
    try {
      _verificationToken = await _repo.resendConfirmationEmail(email);
      if (_verificationToken != null && _verificationToken!.isNotEmpty) {
        emit(EmailConfirmationOtpSent(
            'Confirmation code sent successfully', email));
      } else {
        emit(EmailConfirmationFailure('Failed to send confirmation email'));
      }
    } catch (e) {
      emit(EmailConfirmationFailure(e.toString()));
    }
  }

  Future<void> verifyEmail({
    required String email,
    required String otp,
  }) async {
    if (_verificationToken == null) {
      emit(EmailConfirmationFailure(
          'Please request a new confirmation code first'));
      return;
    }

    emit(EmailConfirmationLoading());
    try {
      final result = await _repo.verifyEmail(
        email: email,
        token: _verificationToken!,
        otp: otp,
      );

      // Update auth info if available in the response
      if (result.containsKey('accessToken') &&
          result.containsKey('refreshToken')) {
        final AuthService authService = getIt<AuthService>();

        await authService.saveAuthInfo(
          accessToken: result['accessToken'],
          refreshToken: result['refreshToken'],
          userId: result['userId'] ?? '',
          role: result['role'] ?? 0,
          email: email,
          confirmed: true, // Mark as confirmed since verification succeeded
        );
      }

      emit(EmailConfirmationVerified('Email verified successfully'));
    } catch (e) {
      emit(EmailConfirmationFailure(e.toString()));
    }
  }

  Future<void> checkEmailConfirmationStatus(String userId) async {
    emit(EmailConfirmationLoading());
    try {
      final isConfirmed = await _repo.checkEmailConfirmationStatus(userId);
      emit(EmailConfirmationStatusChecked(isConfirmed));
    } catch (e) {
      emit(EmailConfirmationFailure(e.toString()));
    }
  }
}
