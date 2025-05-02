class UserProfileUpdateModel {
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? headline;
  final String? profilePicture;
  final String? coverPicture;
  final String? address;
  final String? country;
  final String? city;
  final String? phoneNo;
  final String? biography;
  final String? visibility;
  final bool? allowMessages;
  final bool? allowMessageRequests;

  UserProfileUpdateModel(
      {this.firstName,
      this.lastName,
      this.headline,
      this.address,
      this.country,
      this.city,
      this.phoneNo,
      this.biography,
      this.profilePicture,
      this.coverPicture,
      this.username,
      this.visibility,
      this.allowMessages,
      this.allowMessageRequests});

  // Convert model to JSON for API requests, only including non-null fields
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (firstName != null) data['firstname'] = firstName;
    if (lastName != null) data['lastname'] = lastName;
    if (headline != null) data['headline'] = headline;
    if (address != null) data['address'] = address;
    if (country != null) data['country'] = country;
    if (coverPicture != null) data['coverPicture'] = coverPicture;
    if (profilePicture != null) data['profilePicture'] = profilePicture;
    if (city != null) data['city'] = city;
    if (phoneNo != null) data['phoneNumber'] = phoneNo;
    if (biography != null) data['biography'] = biography;
    if (username != null) data['username'] = username;
    if (visibility != null) data['visibility'] = visibility;
    if (allowMessages != null) data['allowMessages'] = allowMessages;
    if (allowMessageRequests != null)
      data['allowMessageRequests'] = allowMessageRequests;
    return data;
  }

//   // Create an update model from existing UserProfile
//   // factory UserProfileUpdateModel.fromUserProfile(UserProfile profile) {
//   //   return UserProfileUpdateModel(
//   //     firstName: profile.firstname,
//   //     lastName: profile.lastname,
//   //     headline: profile.headline,
//   //     address: profile.address,
//   //     country: profile.country,
//   //     city: profile.city,
//   //     phoneNo: profile.phoneNo,
//   //     biography: profile.about,
//   //   );
//   // }
}
