import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/features/userprofile/data/models/update_user_profile_model.dart';
import 'package:joblinc/features/userprofile/data/repo/user_profile_repository.dart';

import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

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
}
