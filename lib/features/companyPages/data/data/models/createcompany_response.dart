class CreateCompanyResponse {
  final String accessToken;
  final String refreshToken;

  CreateCompanyResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory CreateCompanyResponse.fromJson(Map<String, dynamic> json) {
    return CreateCompanyResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
