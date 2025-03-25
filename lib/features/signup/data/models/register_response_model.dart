class RegisterResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final int role;
  RegisterResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId,
      required this.role});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        userId: json['userId'],
        role: json['role']);
  }
}
