class Follow {
  final String? companyId;
  final String? companyName;
  final String? companyLogo;
  final String userId;
  final String firstname;
  final String lastname;
  final String profilePicture;
  final String headline;
  final DateTime time;

  Follow({
    required this.companyId,
    required this.companyName,
    required this.companyLogo,
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.profilePicture,
    required this.headline,
    required this.time,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
      companyId: json['companyId'] ,
      companyName: json['companyName'] ,
      companyLogo: json['companyLogo'] ,
      userId: json['userId'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      headline: json['headline'] ?? '',
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'userId': userId,
      'firstname': firstname,
      'lastname': lastname,
      'profilePicture': profilePicture,
      'headline': headline,
      'time': time.toIso8601String(),
    };
  }
}
