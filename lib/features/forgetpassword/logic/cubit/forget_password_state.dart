
abstract class ForgotPasswordState{}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordEmailSent extends ForgotPasswordState {
  final String forgotToken;
  ForgotPasswordEmailSent(this.forgotToken);
}

class ForgotPasswordOtpVerified extends ForgotPasswordState {
  final String resetToken;
  ForgotPasswordOtpVerified(this.resetToken);
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final Map<String, dynamic> userData;
  ForgotPasswordSuccess(this.userData);
}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  ForgotPasswordError(this.message);
}
