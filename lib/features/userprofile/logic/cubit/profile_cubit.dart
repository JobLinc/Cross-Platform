import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
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
  final UserConnectionsRepository connectionsRepository;
  ProfileCubit(this._profileRepository, this.connectionsRepository)
      : super(ProfileInitial());

  Future<void> getUserProfile() async {
    try {
      emit(ProfileLoading());
      final profile = await _profileRepository.getUserProfile();
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

  Future<void> deleteProfilePicture() async {
    // emit(RemoveSkill(skill));
    try {
      emit(ProfileUpdating("Deleting profile picture"));
      final response = await _profileRepository.deleteProfilePicture();
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

  Future<void> deleteCoverPicture() async {
    try {
      emit(ProfileUpdating("Deleting cover picture"));
      final response = await _profileRepository.deleteCoverPicture();
      if (response.statusCode == 200) {
        UserProfileUpdateModel expModel = UserProfileUpdateModel();
        updateUserProfile(expModel);
      } else {
        if (!isClosed) {
          print("Failed deletion logic triggered");
          emit(ProfileError('Failed to delete cover picture.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("Exception caught while deleting cover picture");
        emit(ProfileError('Error: $e'));
      }
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
        emit(CertificateAdded("Certificate Added Successfully"));
        // getUserProfile();
      } else {
        if (!isClosed) {
          print("hello I am out");
          emit(CertificateFailed(
              'Failed to add certificate as it already exists'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("hello I am inside");
        emit(CertificateFailed('Error: $e'));
      }
    }
  }

  void editCertificate(Certification certification) async {
    try {
      emit(ProfileUpdating("Editing Certificate"));
      final response =
          await _profileRepository.editCertification(certification);

      if (response.statusCode == 200) {
        UserProfileUpdateModel skillModel = UserProfileUpdateModel();
        updateUserProfile(skillModel);
        emit(CertificateAdded("Certificate Updated Successfully"));
      } else {
        if (!isClosed) {
          emit(CertificateFailed('Failed to Edit Certificate.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(CertificateFailed('Error : ${e.toString()}'));
      }
    }
  }

  Future<void> deleteCertificate(String certificationId) async {
    try {
      final response =
          await _profileRepository.deleteCertification(certificationId);

      if (response.statusCode == 200) {
        // Optionally update profile or UI after deletion
        emit(CertificateDeleted("Certification Deleted succefully"));
        UserProfileUpdateModel picModel = UserProfileUpdateModel();
        updateUserProfile(picModel);

        // getUserProfile();
      } else {
        if (!isClosed) {
          print("Failed deletion logic triggered");
          emit(CertificateFailed('Failed to delete certificate.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("Exception caught while deleting");
        emit(CertificateFailed('Error: $e'));
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
      emit(ProfileUpdating("Adding skill"));
      final response = await _profileRepository.addSkill(skill);

      if (response.statusCode == 200) {
        UserProfileUpdateModel skillModel = UserProfileUpdateModel();
        updateUserProfile(skillModel);
        emit(SkillAdded("Skill Added"));
      } else {
        if (!isClosed) {
          emit(SkillFailed('Failed to add skill.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(SkillFailed('Error : ${e.toString()}'));
      }
    }
  }

  void editSkill(Skill skill) async {
    try {
      emit(ProfileUpdating("Editing skill"));
      final response = await _profileRepository.editSkill(skill);

      if (response.statusCode == 200) {
        UserProfileUpdateModel skillModel = UserProfileUpdateModel();
        updateUserProfile(skillModel);
        emit(SkillAdded("Skill Updated"));
      } else {
        if (!isClosed) {
          emit(SkillFailed('Failed to Edit skill.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(SkillFailed('Error : ${e.toString()}'));
      }
    }
  }

  void removeSkill(String skillid) async {
    // emit(RemoveSkill(skill));
    try {
      emit(ProfileUpdating("Deleting skill"));
      final response = await _profileRepository.deleteSkill(skillid);
      if (response.statusCode == 200) {
        emit(SkillDeleted("Skill Deleted succefully"));
        UserProfileUpdateModel expModel = UserProfileUpdateModel();
        updateUserProfile(expModel);
      } else {
        if (!isClosed) {
          print("Failed deletion logic triggered");
          emit(SkillFailed('Failed to delete experience.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("Exception caught while deleting");
        emit(SkillFailed('Error: $e'));
      }
    }
  }

  void addExperience(ExperienceModel experience) async {
    try {
      emit(ProfilePictureUpdating("Adding experience"));
      final response = await _profileRepository.addExperience(experience);

      if (response.statusCode == 200) {
        UserProfileUpdateModel experienceModel = UserProfileUpdateModel();
        updateUserProfile(experienceModel);
        emit(ExperienceAdded("Experience Added"));
      } else {
        if (!isClosed) {
          emit(ExperienceFailed('Failed to add experience.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(ExperienceFailed('Error: $e'));
      }
    }
  }

  // void addExperienceByCompanyId(ExperienceByCompanyId experience) async {
  //   try {
  //     emit(ProfilePictureUpdating("Adding experience"));
  //     final response = await _profileRepository.addExperienceByCompanyId(experience);

  //     if (response.statusCode == 200) {
  //       UserProfileUpdateModel experienceModel = UserProfileUpdateModel();
  //       updateUserProfile(experienceModel);
  //       emit(ExperienceAdded("Experience Added"));
  //     } else {
  //       if (!isClosed) {
  //         emit(ExperienceFailed('Failed to add experience.'));
  //       }
  //     }
  //   } catch (e) {
  //     if (!isClosed) {
  //       emit(ExperienceFailed('Error: $e'));
  //     }
  //   }
  // }

  void editExperience(ExperienceModel experience) async {
    try {
      emit(ProfileUpdating("Editing Experience"));
      final response = await _profileRepository.editExperience(experience);

      if (response.statusCode == 200) {
        UserProfileUpdateModel expModel = UserProfileUpdateModel();
        updateUserProfile(expModel);
        emit(ExperienceAdded("Experience Updated"));
      } else {
        if (!isClosed) {
          emit(ExperienceFailed('Failed to Edit experience.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(ExperienceFailed('Error: $e'));
      }
    }
  }
  
  void deleteExperience(String position) async {
    try {
      print("hello");
      emit(ProfileUpdating("Deleting Experience"));

      final response = await _profileRepository.deleteExperience(position);

      if (response.statusCode == 200) {
        emit(ExperienceDeleted("Experience Deleted succefully"));
        UserProfileUpdateModel expModel = UserProfileUpdateModel();
        await updateUserProfile(expModel);
      } else {
        if (!isClosed) {
          print("Failed deletion logic triggered");
          emit(ExperienceFailed('Failed to delete experience.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("Exception caught while deleting");
        emit(ExperienceFailed('Error: $e'));
      }
    }
  }

  Future<void> uploadResume(File file) async {
    try {
      emit(ProfileUpdating("Uploading resume"));
      final response = await _profileRepository.uploadResume(file);
      print('Resume uploaded successfully: ${response.data}');
      if (response.statusCode == 200) {
        emit(ResumeAdded("Resume added succefully"));
        UserProfileUpdateModel expModel = UserProfileUpdateModel();

        await updateUserProfile(expModel);
      } else {
        emit(ResumeFailed("Resume adding failed"));
      }
      // You can optionally handle the response here, e.g., update the UI or state
    } catch (e) {
      if (!isClosed) {
        emit(ResumeFailed("Error : ${e.toString()}"));
      }
      print('Error in cubit while uploading resume: $e');
      // You can optionally emit an error state or handle the error gracefully
    }
  }

  Future<void> deleteresume(String resumeid) async {
    try {
      emit(ProfileUpdating("Deleting skill"));
      final response = await _profileRepository.deleteResume(resumeid);
      if (response.statusCode == 200) {
        emit(ResumeAdded("Resume deleted succefully"));
        UserProfileUpdateModel expModel = UserProfileUpdateModel();
        await updateUserProfile(expModel);
      } else {
        if (!isClosed) {
          print("Failed deletion logic triggered");
          emit(ResumeFailed('Failed to delete experience.'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        print("Exception caught while deleting ${e.toString()}");
        emit(ResumeFailed('Error: $e'));
      }
    }
  }

  ///////////////////////////////////OTHERS//////////////////////////
  Future<void> getPublicUserProfile(String userId) async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepository.getPublicUserProfile(userId);
      if (!isClosed) {
        emit(ProfileLoaded(profile));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError('Failed to load public profile: ${e.toString()}'));
      }
    }
  }

  void respondToConnectionInvitation(
      String userId, String status, BuildContext context) async {
    try {
      final response = await connectionsRepository.respondToConnection(
        userId,
        status,
      );

      if (response.statusCode == 200) {
        CustomSnackBar.show(
          context: context,
          message: "Connection $status successfully",
          type: SnackBarType.success,
        );
        getPublicUserProfile(userId);
      } else {
        CustomSnackBar.show(
          context: context,
          message: "Failed to $status connection",
          type: SnackBarType.error,
        );
        getPublicUserProfile(userId);
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
          context: context,
          message: "Couldn't $status the connection",
          type: SnackBarType.error,
        );
      }
    }
  }

  void removeConnection(String userId, BuildContext context) async {
    try {
      final response = await connectionsRepository.changeConnectionStatus(
          userId, "Canceled");
      if (response.statusCode == 200) {
        CustomSnackBar.show(
            context: context,
            message: "connection withdrawn succefully ",
            type: SnackBarType.success);
        getPublicUserProfile(userId);
      } else {
        CustomSnackBar.show(
            context: context,
            message: "connection withdrawing failed ",
            type: SnackBarType.error);
        getPublicUserProfile(userId);
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
            context: context,
            message: "couldn't withdraw connection",
            type: SnackBarType.error);
      }
    }
  }

  void blockConnection(String userId, BuildContext context) async {
    try {
      final response =
          await connectionsRepository.changeConnectionStatus(userId, "Blocked");
      if (response.statusCode == 200) {
        CustomSnackBar.show(
            context: context,
            message: "connection Blocked succefully ",
            type: SnackBarType.success);
        getPublicUserProfile(userId);
      } else {
        CustomSnackBar.show(
            context: context,
            message: "connection Blocking failed ",
            type: SnackBarType.error);
        getPublicUserProfile(userId);
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
            context: context,
            message: "couldn't block connection",
            type: SnackBarType.error);
      }
    }
  }

  void unblockConnection(String userId, BuildContext context) async {
    try {
      final response = await connectionsRepository.changeConnectionStatus(
          userId, "Unblocked");
      if (response.statusCode == 200) {
        CustomSnackBar.show(
            context: context,
            message: "connection Blocked succefully ",
            type: SnackBarType.success);
        getPublicUserProfile(userId);
      } else {
        CustomSnackBar.show(
            context: context,
            message: "connection Blocking failed ",
            type: SnackBarType.error);
        getPublicUserProfile(userId);
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
            context: context,
            message: "couldn't block connection",
            type: SnackBarType.error);
      }
    }
  }

  void followConnection(String userId, BuildContext context) async {
    try {
      final response = await connectionsRepository.follwConnection(userId);
      if (response.statusCode == 200) {
        CustomSnackBar.show(
            context: context,
            message: "connection followed succefully ",
            type: SnackBarType.success);
        getPublicUserProfile(userId);
      } else {
        CustomSnackBar.show(
            context: context,
            message: "connection followed failed ",
            type: SnackBarType.error);
        getPublicUserProfile(userId);
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
            context: context,
            message: "couldn't follow connection",
            type: SnackBarType.error);
      }
    }
  }

  void unfollowConnection(String userId, BuildContext context) async {
    try {
      final response = await connectionsRepository.unfollwConnection(userId);
      if (response.statusCode == 200) {
        CustomSnackBar.show(
            context: context,
            message: "connection unfollowed succefully ",
            type: SnackBarType.success);
        getPublicUserProfile(userId);
      } else {
        CustomSnackBar.show(
            context: context,
            message: "connection unfollowed failed ",
            type: SnackBarType.error);
        getPublicUserProfile(userId);
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
            context: context,
            message: "couldn't unfollow connection",
            type: SnackBarType.error);
      }
    }
  }

  void sendConnectionRequest(String userId, BuildContext context) async {
    try {
      final response = await connectionsRepository.sendConnection(userId);

      if (response.statusCode == 200) {
        CustomSnackBar.show(
          context: context,
          message: "Connection sent successfully",
          type: SnackBarType.success,
        );
        getPublicUserProfile(userId);
      } else {
        CustomSnackBar.show(
          context: context,
          message: "Failed to send connection",
          type: SnackBarType.error,
        );
        getPublicUserProfile(userId);
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
          context: context,
          message: "Couldn't send the connection",
          type: SnackBarType.error,
        );
      }
    }
  }
}
