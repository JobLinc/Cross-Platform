abstract class EmailConfirmationState {}

class EmailConfirmationInitial extends EmailConfirmationState {}

class SendingConfirmationEmail extends EmailConfirmationState {}

class ConfirmationEmailSent extends EmailConfirmationState {
  final String token;

  ConfirmationEmailSent(this.token);
}

class SendConfirmationEmailFailure extends EmailConfirmationState {
  final String error;

  SendConfirmationEmailFailure(this.error);
}

class ConfirmingEmail extends EmailConfirmationState {}

class EmailConfirmed extends EmailConfirmationState {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String role;

  EmailConfirmed({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
  });
}

class ConfirmEmailFailure extends EmailConfirmationState {
  final String error;

  ConfirmEmailFailure(this.error);
}
