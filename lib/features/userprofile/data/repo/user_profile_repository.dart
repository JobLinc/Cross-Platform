import 'dart:io';

import 'package:dio/dio.dart';
import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/data/models/experience_model.dart';
import 'package:joblinc/features/userprofile/data/models/skill_model.dart';
import 'package:joblinc/features/userprofile/data/service/add_service.dart';
import 'package:joblinc/features/userprofile/data/service/others_api_service.dart';
import 'package:joblinc/features/userprofile/data/service/upload_user_picture.dart';
import '../models/user_profile_model.dart';
import '../models/update_user_profile_model.dart';
import '../service/my_user_profile_api.dart';
import '../service/update_user_profile_api.dart';

class UserProfileRepository {
  final UserProfileApiService _apiService;
  final UpdateUserProfileApiService _updateApiService;
  final UploadApiService uploadApiService;
  final addService addApiService;
  final OthersApiService othersApiService;
  // Optional in-memory cache
  UserProfile? _cachedProfile;

  UserProfileRepository(this._apiService, this._updateApiService,
      this.uploadApiService, this.addApiService, this.othersApiService);

  /// Gets the user profile from the API or cache if available and not expired
  Future<UserProfile> getUserProfile({bool forceRefresh = false}) async {
    // if (!forceRefresh && _cachedProfile != null) {
    //   print('Returning cached user profile');
    //   return _cachedProfile!;
    // }

    try {
      // Fetch fresh data from API
      final profile = await _apiService.getUserProfile();

      // Update cache
      _cachedProfile = profile;

      return profile;
    } catch (e) {
      // If we have cached data, return it on error even if expired
      if (_cachedProfile != null && !forceRefresh) {
        print('Error fetching user profile, using cached data: $e');
        return _cachedProfile!;
      }

      rethrow;
    }
  }

  /// Updates the user's personal information
  /// Only the fields included in updateData will be modified
  Future<void> updateUserPersonalInfo(UserProfileUpdateModel updateData) async {
    try {
      print('Updating user personal information');
      await _updateApiService.updateUserPersonalInfo(updateData);

      // Clear cache to force fresh data on next get
      clearCache();

      print('User profile updated successfully');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> uploadProfilePicture(File imageFile) async {
    try {
      return await uploadApiService.uploadProfilePicture(imageFile);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteProfilePicture() async {
    try {
      return await uploadApiService.deleteProfilePicture();
    } catch (e) {
      print('Repository error deleting profile picture: $e');
      rethrow;
    }
  }

  Future<Response> uploadCoverPicture(File imageFile) async {
    try {
      return await uploadApiService.uploadCoverPicture(imageFile);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteCoverPicture() async {
    try {
      return await uploadApiService.deleteCoverPicture();
    } catch (e) {
      print('Repository error deleting cover picture: $e');
      rethrow;
    }
  }

  Future<Response> addCertification(Certification certification) async {
    try {
      return await addApiService.addCertification(certification);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteCertification(String certificationId) async {
    try {
      return await addApiService.deleteCertification(certificationId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Certification>> getAllCertificates() async {
    try {
      final List<dynamic> rawList = await addApiService.getAllCertificates();

      // Safely cast each item to Map<String, dynamic>
      return rawList
          .map((item) => Certification.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addExperience(Experience experience) async {
    try {
      return await addApiService.addExperience(experience);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteExperience(String experienceId) async {
    try {
      return await addApiService.deleteExperience(experienceId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Experience>> getAllExperiences() async {
    try {
      final List<dynamic> rawList = await addApiService.getAllExperiences();

      return rawList
          .map((item) => Experience.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addSkill(Skill skill) async {
    try {
      return await addApiService.addSkill(skill);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> editSkill(Skill skill) async {
    try {
      return await addApiService.editSkill(skill);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteSkill(String skillId) async {
    try {
      return await addApiService.deleteSkill(skillId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Skill>> getAllSkills() async {
    try {
      final List<dynamic> rawList = await addApiService.getAllExperiences();

      return rawList
          .map((item) => Skill.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  void clearCache() {
    _cachedProfile = null;
  }

  Future<Response> uploadResume(File file) async {
    try {
      return await addApiService.uploadResume(file);
    } catch (e) {
      print("Repository error: $e ");
      rethrow;
    }
  }

  Future<Response> deleteResume(String resumeid) async {
    try {
      return await addApiService.deleteUserResume(resumeid);
    } catch (e) {
      print("error ${e.toString()}");
      rethrow;
    }
  }

  /////////////////////////////////Others//////////////////////////////////////
  Future<UserProfile> getPublicUserProfile(String userId) async {
    try {
      return await othersApiService.getPublicUserProfile(userId);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
