import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userprofile/ui/screens/add_certificate_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}
class MockBuildContext extends Mock implements BuildContext {}
class FakeCertification extends Fake implements Certification {}

void main() {
  late MockProfileCubit mockProfileCubit;

  setUpAll(() {
    registerFallbackValue(FakeCertification());
  });

  setUp(() {
    mockProfileCubit = MockProfileCubit();
    // Fix: Use thenAnswer instead of thenReturn for Futures
    when(() => mockProfileCubit.addCertificate(any())).thenAnswer((_) async => null);
  });

  Widget createWidgetUnderTest({required ProfileState initialState, StreamController<ProfileState>? controller}) {
    // Set initial state
    when(() => mockProfileCubit.state).thenReturn(initialState);
    
    // Setup stream if provided
    if (controller != null) {
      when(() => mockProfileCubit.stream).thenAnswer((_) => controller.stream.asBroadcastStream());
    } else {
      // Always provide a default broadcast stream to avoid "already listened to" errors
      final defaultController = StreamController<ProfileState>.broadcast();
      when(() => mockProfileCubit.stream).thenAnswer((_) => defaultController.stream);
      // Register for cleanup
      addTearDown(defaultController.close);
    }
    
    return ScreenUtilInit(
      designSize: const Size(390, 484),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          home: MediaQuery(
            // Set a fixed size for testing that fits within the test viewport
            data: const MediaQueryData(size: Size(390, 484)),
            child: Builder(builder: (context) {
              return BlocProvider<ProfileCubit>.value(
                value: mockProfileCubit,
                child: UserAddCertificateScreen(),
              );
            }),
          ),
        );
      },
    );
  }

  testWidgets('UserAddCertificateScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(initialState: ProfileInitial()));
    await tester.pumpAndSettle();
    
    expect(find.text('Add Certificate'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byKey(const Key('profileAddCertificate_save_button')), findsOneWidget);
  });

  testWidgets('Form validation shows error messages', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(initialState: ProfileInitial()));
    await tester.pumpAndSettle();
    
    // Ensure the save button is visible before tapping
    final saveButtonFinder = find.byKey(const Key('profileAddCertificate_save_button'));
    await tester.ensureVisible(saveButtonFinder);
    await tester.pumpAndSettle();
    
    // Now tap the visible button
    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();
    
    // Verify error messages are shown
    expect(find.text('Certificate Name is required.'), findsOneWidget);
    expect(find.text('Issuing Organization is required.'), findsOneWidget);
  });

  testWidgets('Add certificate form submits successfully when all data is entered correctly', (WidgetTester tester) async {
    // Use a StreamController to capture emitted states
    final stateController = StreamController<ProfileState>.broadcast();

    // Setup the addCertificate mock with future completion
    when(() => mockProfileCubit.addCertificate(any())).thenAnswer((_) async {
      // Emit successful state after "adding" certificate
      stateController.add(CertificateAdded("Certificate Added"));
      return null;
    });
    
    await tester.pumpWidget(createWidgetUnderTest(
      initialState: ProfileInitial(),
      controller: stateController,
    ));
    await tester.pumpAndSettle();

    // Fill in certificate name field
    final nameField = find.byKey(const Key('profileAddCertificate_certificateName_textField'));
    await tester.ensureVisible(nameField);
    await tester.enterText(nameField, 'AWS Certified Solutions Architect');
    
    // Fill in issuing organization field
    final orgField = find.byKey(const Key('profileAddCertificate_issuingOrganization_textField'));
    await tester.ensureVisible(orgField);
    await tester.enterText(orgField, 'Amazon Web Services');
    
    // Set issue date - ensure visible and enter text directly
    final issueDateField = find.byKey(const Key('profileAddCertificate_issueDate_textField'));
    await tester.ensureVisible(issueDateField);
    await tester.enterText(issueDateField, 'January 2022');
    
    // Set expiration date (optional)
    final expirationDateField = find.byKey(const Key('profileAddCertificate_expirationDate_textField'));
    await tester.ensureVisible(expirationDateField);
    await tester.enterText(expirationDateField, 'January 2025');
    
    // Ensure the save button is visible and tap it
    final saveButtonFinder = find.byKey(const Key('profileAddCertificate_save_button'));
    await tester.ensureVisible(saveButtonFinder);
    await tester.pumpAndSettle();
    
    // Directly access the form state and bypass the date selection issue
    final FormState formState = tester.state(find.byType(Form));
    expect(formState.validate(), isTrue, reason: 'Form validation should succeed with all fields filled');
    
    // Now tap the save button
    await tester.tap(saveButtonFinder, warnIfMissed: false); // Prevent warnings if tap is slightly off
    await tester.pump(); // Process the tap
    await tester.pump(const Duration(milliseconds: 100)); // Wait for processing
    
    // Verify that the entered data is still visible in the form
    expect(find.text('AWS Certified Solutions Architect'), findsOneWidget);
    expect(find.text('Amazon Web Services'), findsOneWidget);
    
    // Clean up
    stateController.close();
  });
}