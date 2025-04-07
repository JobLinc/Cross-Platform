class RegisterRequestModel {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String country;
  final String city;
  final String? phoneNumber;

  RegisterRequestModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.country,
    required this.city,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'country': country,
      'city': city,
      'phoneNumber': phoneNumber,
    };
  }
}
