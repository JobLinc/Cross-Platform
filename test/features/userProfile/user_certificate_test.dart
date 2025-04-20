import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userprofile/ui/widgets/user_cerificates.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}
void main() {
  late MockProfileCubit mockProfileCubit;

  setUp(() {
    mockProfileCubit = MockProfileCubit();
  });

  testWidgets('renders UserCerificates UI correctly', (tester) async {
    final certification = Certification(
      certificationId: 'cert1',
      name: 'Flutter Developer',
      organization: 'Google',
      startYear: DateTime(2022, 5),
      endYear: DateTime(2023, 5),
    );

    final profile = UserProfile(
      userId: 'user1',
      firstname: 'John',
      lastname: 'Doe',
      email: 'john@example.com',
      headline: 'Mobile Developer',
      profilePicture: 'pic.jpg',
      coverPicture: 'cover.jpg',
      country: 'USA',
      city: 'New York',
      biography: 'Experienced developer',
      phoneNumber: '1234567890',
      connectionStatus: 'connected',
      numberOfConnections: 10,
      matualConnections: 5,
      recentPosts: [],
      skills: [],
      education: [],
      experiences: [],
      certifications: [certification],
      languages: [],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, __) => MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: mockProfileCubit,
            child: Scaffold(
              body: UserCerificates(profile: profile),
            ),
          ),
        ),
      ),
    );

    // Check header
    expect(find.text('Licenses & Certifications'), findsOneWidget);

    // Check certification name, organization, and formatted date
    expect(find.text('Flutter Developer'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Issued May 2022 • Expired May 2023'), findsOneWidget);

    // Check delete icon is visible
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}
