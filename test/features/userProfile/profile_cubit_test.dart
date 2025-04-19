import 'dart:io'; 
import 'package:bloc_test/bloc_test.dart';
import 'package:joblinc/features/userprofile/data/models/update_user_profile_model.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/data/repo/user_profile_repository.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';


class MockUserProfileRepository extends Mock implements UserProfileRepository {}

void main() {
  late ProfileCubit profileCubit;
  late MockUserProfileRepository mockRepo;


  setUpAll(() {

    registerFallbackValue(UserProfileUpdateModel(
      firstName: 'John',
      lastName: 'Doe',
      username: 'john.doe',
      headline: 'Developer',
      profilePicture: '',
      coverPicture: '',
      address: '123 Street',
      country: 'USA',
      city: 'NY',
      phoneNo: '123456789',
      biography: 'A short bio',
    ));


    registerFallbackValue(File('path/to/dummy/file'));
  });

  setUp(() {
    mockRepo = MockUserProfileRepository();
    profileCubit = ProfileCubit(mockRepo);
  });

  tearDown(() {
    profileCubit.close();
  });

  final dummyProfile = UserProfile(
    userId: '1',
    firstname: 'John',
    lastname: 'Doe',
    email: 'john@example.com',
    headline: 'Developer',
    profilePicture: '',
    coverPicture: '',
    country: 'USA',
    city: 'NY',
    biography: 'Bio here',
    phoneNumber: '123456789',
    connectionStatus: 'connected',
    numberOfConnections: 5,
    matualConnections: 2,
    recentPosts: [],
    skills: [],
    education: [],
    experiences: [],
    certifications: [],
    languages: [],
  );

  group('ProfileCubit Tests', () {
    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when getUserProfile is called successfully',
      build: () {
        when(() => mockRepo.getUserProfile())
            .thenAnswer((_) async => dummyProfile);
        return profileCubit;
      },
      act: (cubit) => cubit.getUserProfile(),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileLoaded>()
            .having((s) => s.profile, 'profile', equals(dummyProfile)),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileUpdating, ProfileUpdated, ProfileLoading, ProfileLoaded] when updateUserProfile succeeds',
      build: () {
        when(() => mockRepo.updateUserPersonalInfo(any()))
            .thenAnswer((_) async {});
        when(() => mockRepo.getUserProfile())
            .thenAnswer((_) async => dummyProfile);
        return profileCubit;
      },
      act: (cubit) =>
          cubit.updateUserProfile(UserProfileUpdateModel(firstName: 'John')),
      expect: () => [
        isA<ProfileUpdating>(), 
        isA<ProfileUpdated>(), 
        isA<ProfileLoading>(), 
        isA<ProfileLoaded>() 
            .having(
                (s) => s.profile,
                'profile',
                equals(
                    dummyProfile)), 
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileUpdating, ProfileError] when uploadProfilePicture fails',
      build: () {
        when(() => mockRepo.uploadProfilePicture(any()))
            .thenThrow(Exception('Failed'));
        return profileCubit;
      },
      act: (cubit) => cubit.uploadProfilePicture(File('path/to/image.png')),
      expect: () => [
        isA<ProfileUpdating>()
            .having((state) => state.operation, 'operation', 'Profile Picture'),
        isA<ProfileError>(), 
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileUpdating, ProfileError] when deleteExperience fails to find matching experience',
      build: () {
        when(() => mockRepo.getAllExperiences()).thenAnswer((_) async => []);
        return profileCubit;
      },
      act: (cubit) => cubit.deleteExperience("Developer"),
      expect: () => [
        isA<ProfileUpdating>().having(
            (state) => state.operation, 'message', 'Deleting Experience'),
        isA<ProfileError>().having(
            (state) => state.message, 'errorMessage', contains('Error:')),
      ],
    );
  });
}
