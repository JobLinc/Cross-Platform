part of 'profile_cubit.dart';

@immutable
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

class ProfilePictureUpdated extends ProfileState {
  final String imageUrl;
  
  ProfilePictureUpdated(this.imageUrl);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}