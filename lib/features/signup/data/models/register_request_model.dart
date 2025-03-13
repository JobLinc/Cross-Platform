class RegisterRequestModel {
  final String firstname;
  final String lastname;
  final String email;
  final String password;

  RegisterRequestModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
    };
  }
}
