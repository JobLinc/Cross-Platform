class SendConfirmationEmailResponse {
  final String token;

  SendConfirmationEmailResponse({required this.token});

  factory SendConfirmationEmailResponse.fromJson(Map<String, dynamic> json) {
    return SendConfirmationEmailResponse(
      token: json['token'],
    );
  }
}
