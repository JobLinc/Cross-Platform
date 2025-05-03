import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/data/models/education_model.dart';
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
  final bool confirmed;
  final int role;
  final String visibility;
  final int plan;
  final bool allowMessages;
  final bool allowMessageRequests;
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
  final List<ExperienceResponse> experiences;
  final List<Certification> certifications;
  final List<Language> languages;
  final List<Resume> resumes;
  final bool isFollowing;

  UserProfile({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.headline,
    required this.profilePicture,
    required this.coverPicture,
    required this.confirmed,
    required this.role,
    required this.visibility,
    required this.plan,
    required this.allowMessages,
    required this.allowMessageRequests,
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
    required this.isFollowing,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      headline: json['headline'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      coverPicture: json['coverPicture'] ?? '',
      confirmed: json['confirmed'] ?? false,
      role: json['role'] ?? 0,
      visibility: json['visibility'] ?? '',
      plan: json['plan'] ?? 0,
      allowMessages: json['allowMessages'] ?? false,
      allowMessageRequests: json['allowMessageRequests'] ?? false,
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
              ?.map((exp) => ExperienceResponse.fromJson(exp))
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
      isFollowing: json['isFollowing'] ?? false,
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
