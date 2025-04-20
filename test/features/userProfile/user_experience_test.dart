import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/userprofile/data/models/experience_model.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userprofile/ui/widgets/user_experiences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}

void main() {
  late MockProfileCubit mockProfileCubit;

  setUp(() {
    mockProfileCubit = MockProfileCubit();
  });

  testWidgets('renders UserExperiences UI with description correctly',
      (tester) async {
    final experience = Experience(
      experienceId: 'exp1',
      position: 'Software Engineer',
      company: 'Tech Corp',
      startDate: DateTime(2020, 2),
      endDate: DateTime(2022, 12),
      description: 'Worked on mobile and web applications.',
    );

    final profile = UserProfile(
      userId: 'user1',
      firstname: 'Alice',
      lastname: 'Smith',
      email: 'alice@example.com',
      headline: 'Lead Developer',
      profilePicture: 'profile.jpg',
      coverPicture: 'cover.jpg',
      country: 'USA',
      city: 'LA',
      biography: 'Engineer at heart',
      phoneNumber: '555-1234',
      connectionStatus: 'connected',
      numberOfConnections: 120,
      matualConnections: 30,
      recentPosts: [],
      skills: [],
      education: [],
      experiences: [experience],
      certifications: [],
      languages: [],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, __) => MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: mockProfileCubit,
            child: Scaffold(
              body: UserExperiences(profile: profile),
            ),
          ),
        ),
      ),
    );

    // Check static content
    expect(find.text('Experiences'), findsOneWidget);
    expect(find.text('Software Engineer'), findsOneWidget);
    expect(find.text('Tech Corp'), findsOneWidget);
    expect(find.text('Feb 2020 • Dec 2022'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}
