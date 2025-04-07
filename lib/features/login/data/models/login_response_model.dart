class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final int role;
  final bool confirmed;
  final String email;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
    required this.confirmed,
    required this.email,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      email: json['email'] ?? '',
      role: json['role'],
      confirmed: json['confirmed'] ?? false,
    );
  }
}
