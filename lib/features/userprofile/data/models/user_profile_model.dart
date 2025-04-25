import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/data/models/experience_model.dart';
import 'package:joblinc/features/userprofile/data/models/resume_model.dart';
import 'package:joblinc/features/userprofile/data/models/skill_model.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';

class UserProfile {
  final String userId;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String headline;
  final String profilePicture;
  final String coverPicture;
  final String connectionStatus;
  final String country;
  final String city;
  final String biography;
  final String phoneNumber;
  final int numberOfConnections;
  final int matualConnections;
  final List<PostModel> recentPosts;
  final List<Skill> skills;
  final List<Education> education;
  final List<Experience> experiences;
  final List<Certification> certifications;
  final List<Language> languages;
  final List<Resume> resumes;

  UserProfile({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.headline,
    required this.profilePicture,
    required this.coverPicture,
    required this.country,
    required this.city,
    required this.biography,
    required this.phoneNumber,
    required this.connectionStatus,
    required this.numberOfConnections,
    required this.matualConnections,
    required this.recentPosts,
    required this.skills,
    required this.education,
    required this.experiences,
    required this.certifications,
    required this.languages,
    required this.resumes,
    required this.username,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      headline: json['headline'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      coverPicture: json['coverPicture'] ?? '',
      connectionStatus: json['connectionStatus'] ?? 'NotConnected',
      numberOfConnections: json['numberOfConnections'] ?? 0,
      matualConnections: json['mutualConnections'] ?? 0,
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      biography: json['biography'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      recentPosts: (json['recentPosts'] as List<dynamic>?)
              ?.map((post) => PostModel.fromJson(post))
              .toList() ??
          [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((skill) => Skill.fromJson(skill))
              .toList() ??
          [],
      education: (json['education'] as List<dynamic>?)
              ?.map((edu) => Education.fromJson(edu))
              .toList() ??
          [],
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((exp) => Experience.fromJson(exp))
              .toList() ??
          [],
      certifications: _parseCertifications(json['certificates']),
      languages: (json['languages'] as List<dynamic>?)
              ?.map((lang) => Language.fromJson(lang))
              .toList() ??
          [],
      email: json['email'] ?? '',
      resumes: (json['resumes'] as List<dynamic>?)
              ?.map((resume) => Resume.fromJson(resume))
              .toList() ??
          [],
      username: json['username'] ?? '',
    );
  }

  static List<Certification> _parseCertifications(dynamic certificationsJson) {
    if (certificationsJson == null) {
      return [];
    }

    try {
      List<dynamic> certList = certificationsJson as List<dynamic>;
      return certList.map((cert) => Certification.fromJson(cert)).toList();
    } catch (e) {
      print('Error parsing certifications: $e');
      return [];
    }
  }

  //TODO add PostModel.toJson() before uncommenting
  // Map<String, dynamic> toJson() {
  //   return {
  //     'userId': userId,
  //     'firstname': firstname,
  //     'lastname': lastname,
  //     'email': email,
  //     'headline': headline,
  //     'profilePicture': profilePicture,
  //     'coverPicture': coverPicture,
  //     'country': country,
  //     'city': city,
  //     'biography': biography,
  //     'phoneNumber': phoneNumber,
  //     'connectionStatus': connectionStatus,
  //     'numberOfConnections': numberOfConnections,
  //     'mutualConnections': matualConnections,
  //     'recentPosts': recentPosts.map((post) => post.toJson()).toList(),
  //     'skills': skills.map((skill) => skill.toJson()).toList(),
  //     'education': education.map((edu) => edu.toJson()).toList(),
  //     'experience': experience.map((exp) => exp.toJson()).toList(),
  //     'certifications': certifications.map((cert) => cert.toJson()).toList(),
  //     'languages': languages.map((lang) => lang.toJson()).toList(),
  //   };
  // }
}

// class Post {
//   final String postId;
//   final PostContent content;
//   final int timestamp;
//   final int likes;
//   final int comments;
//   final int shares;

//   Post({
//     required this.postId,
//     required this.content,
//     required this.timestamp,
//     required this.likes,
//     required this.comments,
//     required this.shares,
//   });

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       postId: json['postId'] ?? '',
//       content: PostContent.fromJson(json['content'] ?? {}),
//       timestamp: json['timestamp'] ?? 0,
//       likes: json['likes'] ?? 0,
//       comments: json['comments'] ?? 0,
//       shares: json['shares'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'postId': postId,
//       'content': content.toJson(),
//       'timestamp': timestamp,
//       'likes': likes,
//       'comments': comments,
//       'shares': shares,
//     };
//   }
// }

// class PostContent {
//   final String text;
//   final String? image;

//   PostContent({
//     required this.text,
//     this.image,
//   });

//   factory PostContent.fromJson(Map<String, dynamic> json) {
//     return PostContent(
//       text: json['text'] ?? '',
//       image: json['image'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'text': text,
//       if (image != null) 'image': image,
//     };
//   }
// }

class Education {
  final String educationId;
  final String school;
  final String degree;
  final String fieldOfStudy;
  final int startYear;
  final int? endYear;

  Education({
    required this.educationId,
    required this.school,
    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    this.endYear,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      educationId: json['educationId'] ?? '',
      school: json['school'] ?? '',
      degree: json['degree'] ?? '',
      fieldOfStudy: json['fieldOfStudy'] ?? '',
      startYear: json['startYear'] ?? 0,
      endYear: json['endYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'educationId': educationId,
      'school': school,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'startYear': startYear,
      if (endYear != null) 'endYear': endYear,
    };
  }
}

class Language {
  final String languageId;
  final String name;
  final String proficiency;

  Language({
    required this.languageId,
    required this.name,
    required this.proficiency,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      languageId: json['languageId'] ?? '',
      name: json['name'] ?? '',
      proficiency: json['proficiency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageId': languageId,
      'name': name,
      'proficiency': proficiency,
    };
  }
}
