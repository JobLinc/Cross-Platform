import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/data/models/experience_model.dart';
import 'package:joblinc/features/userprofile/data/models/skill_model.dart';
import 'package:joblinc/features/userprofile/data/models/update_user_profile_model.dart';
import 'package:joblinc/features/userprofile/data/repo/user_profile_repository.dart';

import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  String firstname = "";
  final UserProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  Future<void> getUserProfile() async {
    try {
      emit(ProfileLoading());
      final profile = await _profileRepository.getUserProfile();
      firstname = profile.firstname;
      if (!isClosed) {
        emit(ProfileLoaded(profile));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError('Failed to load profile: ${e.toString()}'));
      }
    }
  }

  Future<void> updateUserProfile(UserProfileUpdateModel updateData) async {
    try {
      emit(ProfileUpdating());
      await _profileRepository.updateUserPersonalInfo(updateData);
      emit(ProfileUpdated());
      // Reload the profile to get the updated data
      getUserProfile();
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError('Failed to update profile: ${e.toString()}'));
      }
    }
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    // UserProfileUpdateModel updateData =
    //     UserProfileUpdateModel(profilePicture: imageFile.path);
    try {
      // Call the repository to upload the image
      emit(ProfileUpdating("Profile Picture"));
      Response response =
          await _profileRepository.uploadProfilePicture(imageFile);

      if (response.statusCode == 200) {
        UserProfileUpdateModel picModel =
            UserProfileUpdateModel(firstName: response.data["firstname"]);
        updateUserProfile(picModel);
        // getUserProfile();
      } else {
        emit(ProfileError('Failed to upload profile picture'));
      }
    } catch (e) {
      emit(ProfileError('Error: $e'));
    }
  }

  Future<void> uploadCoverPicture(File imageFile) async {
    // UserProfileUpdateModel updateData =
    //     UserProfileUpdateModel(profilePicture: imageFile.path);
    try {
      // Call the repository to upload the image
      emit(ProfileUpdating("Cover Picture"));
      Response response =
          await _profileRepository.uploadCoverPicture(imageFile);

      if (response.statusCode == 200) {
        UserProfileUpdateModel picModel =
            UserProfileUpdateModel(firstName: response.data["firstname"]);
        updateUserProfile(picModel);
      } else {
        emit(ProfileError('Failed to upload profile picture'));
      }
    } catch (e) {
      emit(ProfileError('Error: $e'));
    }
  }

  void updateprofilepicture(String imagepath) {
    emit(ProfilePictureUpdating(imagepath));
  }

  void updatecoverpicture(String imagepath) {
    emit(CoverPictureUpdating(imagepath));
  }

  // Future<void> updateProfilePicture(String imagePath) async {
  //   try {
  //     emit(ProfileUpdating());
  //     await _profileRepository.updateProfilePicture(imagePath);
  //     emit(ProfilePictureUpdated());
  //     // Reload the profile to get the updated picture
  //     getUserProfile();
  //   } catch (e) {
  //     emit(ProfileError('Failed to update profile picture: ${e.toString()}'));
  //   }
  // }

  Future<void> addCertificate(Certification certification) async {
    // UserProfileUpdateModel updateData =
    //     UserProfileUpdateModel(profilePicture: imageFile.path);
    try {
      // Call the repository to upload the image
      emit(ProfileUpdating("Profile Picture"));
      final response = await _profileRepository.addCertification(certification);

      if (response.statusCode == 200) {
        UserProfileUpdateModel picModel = UserProfileUpdateModel();
        updateUserProfile(picModel);
        emit(CertificateAdded("Certificate Added"));
        // getUserProfile();
      } else {
        if (!isClosed) {
          print("hello I am out");
          emit(ProfileError('Failed to add certificate as it already exists'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("hello I am inside");
        emit(ProfileError('Error: $e'));
      }
    }
  }

  Future<void> deleteCertificate(String name) async {
    try {
      emit(ProfileUpdating("Deleting Certificate"));
      String certificationId;
      final certificates = await _profileRepository.getAllCertificates();

      certificationId =
          certificates.firstWhere((cert) => cert.name == name).certificationId;

      print(certificates);
      print(certificationId);
      final response =
          await _profileRepository.deleteCertification(certificationId);

      if (response.statusCode == 200) {
        // Optionally update profile or UI after deletion
        UserProfileUpdateModel picModel = UserProfileUpdateModel();
        updateUserProfile(picModel);
        // getUserProfile();
      } else {
        if (!isClosed) {
          print("Failed deletion logic triggered");
          emit(ProfileError('Failed to delete certificate.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("Exception caught while deleting");
        emit(ProfileError('Error: $e'));
      }
    }
  }

  // void removeCertificate(String certificateId) {
  //   emit(RemoveCertificate(certificateId));
  // }

  // void updateCertificate(Certification certificate) {
  //   emit(UpdateCertificate(certificate));
  // }

  void addSkill(Skill skill) async {
    try {
      emit(ProfileUpdating("Adding experience"));
      final response = await _profileRepository.addSkill(skill);

      if (response.statusCode == 200) {
        UserProfileUpdateModel skillModel = UserProfileUpdateModel();
        updateUserProfile(skillModel);
        emit(SkillAdded("Skill Added"));
      } else {
        if (!isClosed) {
          emit(ProfileError('Failed to add skill.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError('Error: $e'));
      }
    }
  }

  void removeSkill(String skillid) async {
    // emit(RemoveSkill(skill));
    try {
      emit(ProfileUpdating("Deleting skill"));
      final response = await _profileRepository.deleteSkill(skillid);
      if (response.statusCode == 200) {
        UserProfileUpdateModel expModel = UserProfileUpdateModel();
        updateUserProfile(expModel);
      } else {
        if (!isClosed) {
          print("Failed deletion logic triggered");
          emit(ProfileError('Failed to delete experience.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("Exception caught while deleting");
        emit(ProfileError('Error: $e'));
      }
    }
  }

  void addExperience(Experience experience) async {
    try {
      emit(ProfilePictureUpdating("Adding experience"));
      final response = await _profileRepository.addExperience(experience);

      if (response.statusCode == 200) {
        UserProfileUpdateModel experienceModel = UserProfileUpdateModel();
        updateUserProfile(experienceModel);
        emit(ExperienceAdded("Experience Added"));
      } else {
        if (!isClosed) {
          emit(ProfileError('Failed to add experience.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError('Error: $e'));
      }
    }
  }

  void deleteExperience(String position) async {
    try {
      print("hello");
      emit(ProfileUpdating("Deleting Experience"));
      String experienceId;
      final experiences = await _profileRepository.getAllExperiences();

      experienceId = experiences
          .firstWhere((exp) => exp.position == position)
          .experienceId;

      print(experiences);
      print(experienceId);
      final response = await _profileRepository.deleteExperience(experienceId);

      if (response.statusCode == 200) {
        UserProfileUpdateModel expModel = UserProfileUpdateModel();
        updateUserProfile(expModel);
      } else {
        if (!isClosed) {
          print("Failed deletion logic triggered");
          emit(ProfileError('Failed to delete experience.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("Exception caught while deleting");
        emit(ProfileError('Error: $e'));
      }
    }
  }
}
