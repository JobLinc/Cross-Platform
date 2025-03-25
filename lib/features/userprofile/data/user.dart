class User {
  final String firstName;
  final String lastName;
  final String headline;
  final String? profilePicture;
  final String? coverPicture;
  final String? about;
  final int connections;

  User({
    required this.firstName,
    required this.lastName,
    required this.headline,
    this.profilePicture,
    this.coverPicture,
    this.about,
    required this.connections,
  });
}
