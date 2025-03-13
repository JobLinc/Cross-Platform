class RegisterResponse {
  final String accessToken;
  final String refreshToken;

  RegisterResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      accessToken: json['data']['accessToken'],
      refreshToken: json['data']['refreshToken'],
    );
  }
}
