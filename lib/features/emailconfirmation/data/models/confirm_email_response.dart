class ConfirmEmailResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String role;
  final String confirmed;

  ConfirmEmailResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
    required this.confirmed,
  });

  factory ConfirmEmailResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    print(json['accessToken']);
    print(json['refreshToken']);
    print(json['userId']);
    print(json['role']);
    print(json['confirmed']);
    return ConfirmEmailResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      role: json['role'],
      confirmed: json['confirmed'] ?? true,
    );
  }
}
