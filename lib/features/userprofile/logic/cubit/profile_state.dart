part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded(this.profile);
}

class ProfileUpdating extends ProfileState {
  final String operation;

  ProfileUpdating([this.operation = 'profile']);
}

class ProfileUpdated extends ProfileState {
  final String message;

  ProfileUpdated([this.message = 'Profile updated successfully']);
}

class ProfilePictureUpdating extends ProfileState {
  String imagepath;
  ProfilePictureUpdating(this.imagepath);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
