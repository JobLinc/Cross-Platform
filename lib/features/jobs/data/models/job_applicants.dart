class JobApplicant {
  final String id;
  final String job;
  final Applicant applicant;
  final String phone;
  final Resume resume;
  final String status;
  final DateTime createdAt;

  JobApplicant({
    required this.id,
    required this.job,
    required this.applicant,
    required this.phone,
    required this.resume,
    required this.status,
    required this.createdAt,
  });

  factory JobApplicant.fromJson(Map<String, dynamic> json) {
    return JobApplicant(
      id: json['id'],
      job: json['job'],
      applicant: Applicant.fromJson(json['applicant']),
      phone: json['phone'],
      resume: Resume.fromJson(json['resume']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'job': job,
        'applicant': applicant.toJson(),
        'phone': phone,
        'resume': resume.toJson(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };
}

class Applicant {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String username;
  final String profilePicture;
  final String country;
  final String city;
  //final String phoneNumber;

  Applicant({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.username,
    required this.profilePicture,
    required this.country,
    required this.city,
    //required this.phoneNumber,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      username: json['username'],
      profilePicture: json['profilePicture'],
      country: json['country'],
      city: json['city'],
      //phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'username': username,
        'profilePicture': profilePicture,
        'country': country,
        'city': city,
        //'phoneNumber': phoneNumber,
      };
}

class Resume {
  final String id;
  final String name;
  final String file;
  final String type;
  final int size;

  Resume({
    required this.id,
    required this.name,
    required this.file,
    required this.type,
    required this.size,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'],
      name: json['name'],
      file: json['file'],
      type: json['type'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'file': file,
        'type': type,
        'size': size,
      };
}
