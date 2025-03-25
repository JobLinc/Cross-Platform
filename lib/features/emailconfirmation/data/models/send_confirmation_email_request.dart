class SendConfirmationEmailRequest {
  final String email;

  SendConfirmationEmailRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
