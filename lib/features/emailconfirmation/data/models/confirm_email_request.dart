class ConfirmEmailRequest {
  final String email;
  final String token;
  final String otp;

  ConfirmEmailRequest(
      {required this.email, required this.token, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'otp': otp,
    };
  }
}
