import 'package:bloc/bloc.dart';
import 'package:joblinc/features/userProfile/data/models/update_user_profile_model.dart';
import 'package:joblinc/features/userProfile/data/repo/user_profile_repository.dart';
import 'package:meta/meta.dart';
import 'package:joblinc/features/userProfile/data/models/user_profile_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  Future<void> getUserProfile() async {
    try {
      emit(ProfileLoading());
      final profile = await _profileRepository.getUserProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
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
      emit(ProfileError('Failed to update profile: ${e.toString()}'));
    }
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