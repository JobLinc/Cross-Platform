class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final int role;
  final String email;
  final bool confirmed;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
    required this.email,
    required this.confirmed,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      role: json['role'],
      email: json['email'] ?? '',
      confirmed: json['confirmed'] ?? false,
    );
  }
}
