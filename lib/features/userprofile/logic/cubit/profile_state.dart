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

class CoverPictureUpdating extends ProfileState {
  String imagepath;
  CoverPictureUpdating(this.imagepath);
}

// TODO : Uncomment these states when implementing the respective features

class AddingCertificate extends ProfileState {
  final String message;

  AddingCertificate(this.message);
}

class CertificateAdded extends ProfileState {
  final String message;

  CertificateAdded(this.message);
}

// class CertificateUpdated extends ProfileState {
//   final String message;

//   CertificateUpdated(this.message);
// }

class CertificateDeleted extends ProfileState {
  final String message;

  CertificateDeleted(this.message);
}

class AddingSkill extends ProfileState {
  final String message;

  AddingSkill(this.message);
}

class SkillAdded extends ProfileState {
  final String message;

  SkillAdded(this.message);
}

// class SkillUpdated extends ProfileState {
//   final String message;

//   SkillUpdated(this.message);
// }

class SkillDeleted extends ProfileState {
  final String message;

  SkillDeleted(this.message);
}

class ExperienceAdded extends ProfileState {
  final String message;

  ExperienceAdded(this.message);
}

class ResumeAdded extends ProfileState {
  final String message;

  ResumeAdded(this.message);
}

class ResumeFailed extends ProfileState {
  final String message;

  ResumeFailed(this.message);
}

class SkillFailed extends ProfileState {
  final String message;

  SkillFailed(this.message);
}

class ExperienceFailed extends ProfileState {
  final String message;

  ExperienceFailed(this.message);
}

class CertificateFailed extends ProfileState {
  final String message;

  CertificateFailed(this.message);
}
// class ExperienceUpdated extends ProfileState {
//   final String message;

//   ExperienceUpdated(this.message);
// }

class ExperienceDeleted extends ProfileState {
  final String message;

  ExperienceDeleted(this.message);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
