class RegisterResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final int role;
  final bool confirmed;

  RegisterResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
    required this.confirmed,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        userId: json['userId'],
        role: json['role'],
        confirmed: json['confirmed'] ?? false);
  }
}
