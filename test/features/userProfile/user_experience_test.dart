import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/companypages/data/data/models/getmycompany_response.dart';
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
    final experience = ExperienceResponse(
      id: 'exp1',
      position: 'Software Engineer',
      startDate: DateTime(2020, 2),
      endDate: 'Present',
      company: CompanyResponse(
        id: 'comp1',
        urlSlug: 'tech-corp',
        industry: 'Technology',
        size: '100-500',
        type: 'Private',
        overview: 'Leading tech company',
        website: 'https://techcorp.com',
        name: 'Tech Corp',
        logo: 'logo.png',
        isFollowing: false,
      ),
      description: 'Worked on mobile and web applications.',
      mode: 'Full-time',
      type: 'On-site',
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
    expect(find.text('Tech Corp • Full-time'), findsOneWidget);
    expect(find.text('Feb 2020 - Dec 2022'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}

// Define a Company class if it doesn't exist in your main code
class Company {
  final String name;
  final String? logo;

  Company({required this.name, this.logo});
}
