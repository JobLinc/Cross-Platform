class UserExperience {
  String id;
  String company;
  String position;
  DateTime startDate;
  DateTime endDate;
  String description;

  UserExperience({
    required this.id,
    required this.company,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  factory UserExperience.fromJson(Map<String, dynamic> json) {
    return UserExperience(
      id: json['_id'],
      company: json['company'],
      position: json['position'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'company': company,
      'position': position,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
    };
  }
}

class UserCertificate {
  String id;
  String name;
  String organization;
  DateTime issueDate;
  DateTime expirationDate;

  UserCertificate({
    required this.id,
    required this.name,
    required this.organization,
    required this.issueDate,
    required this.expirationDate,
  });

  factory UserCertificate.fromJson(Map<String, dynamic> json) {
    return UserCertificate(
      id: json['_id'],
      name: json['name'],
      organization: json['organization'],
      issueDate: DateTime.parse(json['issueDate']),
      expirationDate: DateTime.parse(json['expirationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'organization': organization,
      'issueDate': issueDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
    };
  }
}

class UserSkill {
  String id;
  String name;
  int level;

  UserSkill({
    required this.id,
    required this.name,
    required this.level,
  });

  factory UserSkill.fromJson(Map<String, dynamic> json) {
    return UserSkill(
      id: json['_id'],
      name: json['name'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'level': level,
    };
  }
}

class UserEducation {
  String id;
  String name;
  String degree;
  String fieldOfStudy;
  DateTime startDate;
  DateTime endDate;
  String description;
  double CGPA;

  UserEducation({
    required this.id,
    required this.name,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.CGPA,
  });

  factory UserEducation.fromJson(Map<String, dynamic> json) {
    return UserEducation(
      id: json['_id'],
      name: json['name'],
      degree: json['degree'],
      fieldOfStudy: json['fieldOfStudy'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json['description'],
      CGPA: json['CGPA'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
      'CGPA': CGPA,
    };
  }
}

class UserChat {
  String userId;
  String chatId;

  UserChat({
    required this.userId,
    required this.chatId,
  });

  factory UserChat.fromJson(Map<String, dynamic> json) {
    return UserChat(
      userId: json['userId'],
      chatId: json['chatId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'chatId': chatId,
    };
  }
}

class ResetPasswordRequest {
  String status;
  String forgotToken;
  String otp;
  String resetToken;
  DateTime createdAt;
  DateTime updatedAt;

  ResetPasswordRequest({
    required this.status,
    required this.forgotToken,
    required this.otp,
    required this.resetToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequest(
      status: json['status'],
      forgotToken: json['forgotToken'],
      otp: json['otp'],
      resetToken: json['resetToken'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'forgotToken': forgotToken,
      'otp': otp,
      'resetToken': resetToken,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class User {
  String id;
  String firstname;
  String lastname;
  String username;
  String email;
  String password;
  String country;
  String city;
  String phoneNumber;
  List<String>? refreshToken;
  String? profile;
  String visibility;
  String role;
  bool isPremiumUser;
  List<UserExperience> experiences;
  List<UserCertificate> certificates;
  List<UserSkill> skills;
  List<UserEducation> education;
  List<String> managedCompanies;
  List<ResetPasswordRequest> passwordResetRequests;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.password,
    required this.country,
    required this.city,
    required this.phoneNumber,
    this.refreshToken,
    this.profile,
    required this.visibility,
    required this.role,
    required this.isPremiumUser,
    required this.experiences,
    required this.certificates,
    required this.skills,
    required this.education,
    required this.managedCompanies,
    required this.passwordResetRequests,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      country: json['country'],
      city: json['city'],
      phoneNumber: json['phoneNumber'],
      refreshToken: json['refreshToken'] != null
          ? List<String>.from(json['refreshToken'])
          : null,
      profile: json['profile'],
      visibility: json['visibility'],
      role: json['role'],
      isPremiumUser: json['isPremiumUser'],
      experiences: (json['experiences'] as List)
          .map((e) => UserExperience.fromJson(e))
          .toList(),
      certificates: (json['certificates'] as List)
          .map((c) => UserCertificate.fromJson(c))
          .toList(),
      skills: (json['skills'] as List)
          .map((s) => UserSkill.fromJson(s))
          .toList(),
      education: (json['education'] as List)
          .map((edu) => UserEducation.fromJson(edu))
          .toList(),
      managedCompanies: List<String>.from(json['managedCompanies']),
      passwordResetRequests: (json['passwordResetRequests'] as List)
          .map((r) => ResetPasswordRequest.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'password': password,
      'country': country,
      'city': city,
      'phoneNumber': phoneNumber,
      'refreshToken': refreshToken,
      'profile': profile,
      'visibility': visibility,
      'role': role,
      'isPremiumUser':isPremiumUser,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'certificates': certificates.map((c) => c.toJson()).toList(),
      'skills': skills.map((s) => s.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'managedCompanies': managedCompanies,
      'passwordResetRequests':
          passwordResetRequests.map((r) => r.toJson()).toList(),
    };
  }
}


  // Mock User Object
  User mockMainUser = User(
    id: "60d0fe4f5311236168a109ca",
    firstname: "John",
    lastname: "Doe",
    username: "johndoe",
    email: "abdelrahmansameh092@gmail.com",
    password: "securepassword",
    country: "USA",
    city: "New York",
    phoneNumber: "+1234567890",
    refreshToken: ["token1", "token2"],
    profile: "https://example.com/profile.jpg",
    visibility: "public",
    role: "user",
    isPremiumUser: false,
    experiences: [
      UserExperience(
        id: "exp1",
        company: "Google",
        position: "Software Engineer",
        startDate: DateTime(2020, 1, 1),
        endDate: DateTime(2023, 1, 1),
        description: "Worked on Flutter apps.",
      ),
    ],
    certificates: [
      UserCertificate(
        id: "cert1",
        name: "AWS Certified Developer",
        organization: "Amazon",
        issueDate: DateTime(2022, 5, 10),
        expirationDate: DateTime(2025, 5, 10),
      ),
    ],
    skills: [
      UserSkill(
        id: "skill1",
        name: "Flutter",
        level: 5,
      ),
      UserSkill(
        id: "skill2",
        name: "Dart",
        level: 5,
      ),
    ],
    education: [
      UserEducation(
        id: "edu1",
        name: "MIT",
        degree: "BSc in Computer Science",
        fieldOfStudy: "Software Engineering",
        startDate: DateTime(2016, 9, 1),
        endDate: DateTime(2020, 6, 30),
        description: "Graduated with honors.",
        CGPA: 3.9,
      ),
    ],
    managedCompanies: ["company1", "company2"],
    passwordResetRequests: [
      ResetPasswordRequest(
        status: "pending",
        forgotToken: "abc123",
        otp: "567890",
        resetToken: "xyz789",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ],
  );

