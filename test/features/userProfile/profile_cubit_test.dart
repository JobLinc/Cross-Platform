import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/userprofile/data/models/update_user_profile_model.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/data/repo/user_profile_repository.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

class MockUserConnectionsRepository extends Mock
    implements UserConnectionsRepository {}

void main() {
  late ProfileCubit profileCubit;
  late MockUserProfileRepository mockRepo;
  late MockUserConnectionsRepository mockConnectionsRepo;

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
    mockConnectionsRepo = MockUserConnectionsRepository();
    profileCubit = ProfileCubit(mockRepo, mockConnectionsRepo);
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
    resumes: [],
    username: 'alolo',
    confirmed: true,
    role: 0,
    visibility: "public",
    plan: 0,
    isFollowing: false,
    allowMessages: true,
    allowMessageRequests: true,
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
            .having((s) => s.profile, 'profile', equals(dummyProfile)),
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
      'emits [ProfileUpdating, ExperienceFailed] when deleteExperience fails',
      build: () {
        when(() => mockRepo.deleteExperience(any()))
            .thenThrow(Exception('Failed to delete experience'));
        return profileCubit;
      },
      act: (cubit) => cubit.deleteExperience("exp-123"),
      expect: () => [
        isA<ProfileUpdating>().having(
            (state) => state.operation, 'operation', 'Deleting Experience'),
        isA<ExperienceFailed>(),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when getPublicUserProfile is called successfully',
      build: () {
        when(() => mockRepo.getPublicUserProfile(any()))
            .thenAnswer((_) async => dummyProfile);
        return profileCubit;
      },
      act: (cubit) => cubit.getPublicUserProfile('userId123'),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileLoaded>()
            .having((s) => s.profile, 'profile', equals(dummyProfile)),
      ],
    );
  });
}
