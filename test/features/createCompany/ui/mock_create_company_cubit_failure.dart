import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/submit_company.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/companypages/ui/screens/create_company.dart';
import 'package:joblinc/features/companypages/logic/cubit/create_company_cubit.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/repos/createcompany_repo.dart';
import 'package:get_it/get_it.dart';

// Mock classes
class MockCreateCompanyCubit extends MockCubit<CreateCompanyState>
    implements CreateCompanyCubit {}

class MockCreateCompanyRepo extends Mock implements CreateCompanyRepo {}

class FakeCreateCompanyState extends Fake implements CreateCompanyState {}

void main() {
  late MockCreateCompanyCubit mockCreateCompanyCubit;
  final getIt = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeCreateCompanyState());
    registerFallbackValue(Industry.technology);
    registerFallbackValue(OrganizationSize.zeroToOne);
    registerFallbackValue(OrganizationType.privatelyHeld);
  });

  setUp(() {
    // Clear any existing registrations
    getIt.reset();

    // Register mock repository
    getIt.registerSingleton<CreateCompanyRepo>(MockCreateCompanyRepo());

    mockCreateCompanyCubit = MockCreateCompanyCubit();
    when(() => mockCreateCompanyCubit.state).thenReturn(CreateCompanyInitial());
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('does not call createCompany when checkbox is unchecked',
      (tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider<CreateCompanyCubit>.value(
              value: mockCreateCompanyCubit,
              child: CreateCompanyPage(),
            ),
          );
        },
      ),
    );

    // Verify initial state
    expect(find.byType(CreateCompanyPage), findsOneWidget);

    // Find all form fields
    final nameField = find.byKey(const Key('createcompany_name_textfield'));
    final jobLincUrlField =
        find.byKey(const Key('createcompany_jobLincUrl_textfield'));
    final websiteField =
        find.byKey(const Key('createcompany_website_textfield'));
    final overviewField =
        find.byKey(const Key('createcompany_overview_textfield'));

    // Verify fields exist before interacting
    expect(nameField, findsOneWidget);
    expect(jobLincUrlField, findsOneWidget);
    expect(websiteField, findsOneWidget);
    expect(overviewField, findsOneWidget);

    // Fill out the form
    await tester.enterText(nameField, 'Test Company');
    await tester.enterText(jobLincUrlField, 'test-company');
    await tester.enterText(websiteField, 'https://test.com');
    await tester.enterText(overviewField, 'Test overview');

    // Select dropdown values
    await _selectDropdownValue(
      tester,
      'createcompany_industry_dropdown',
      Industry.technology.displayName,
    );
    await _selectDropdownValue(
      tester,
      'createcompany_orgSize_dropdown',
      OrganizationSize.twoHundredOneToFiveHundred.displayName,
    );
    await _selectDropdownValue(
      tester,
      'createcompany_orgType_dropdown',
      OrganizationType.privatelyHeld.displayName,
    );

    // Ensure checkbox is unchecked (default state)
    final checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);
    expect(tester.widget<Checkbox>(checkbox).value, isFalse);

    // Attempt to submit
    await tester.tap(find.byType(SubmitCompany));
    await tester.pumpAndSettle();

    // Verify the cubit was never called
    verifyNever(() => mockCreateCompanyCubit.createCompany(
          nameController: any(named: 'nameController'),
          jobLincUrlController: any(named: 'jobLincUrlController'),
          selectedIndustry: any(named: 'selectedIndustry'),
          orgSize: any(named: 'orgSize'),
          orgType: any(named: 'orgType'),
          websiteController: any(named: 'websiteController'),
          overviewController: any(named: 'overviewController'),
        ));

    // Verify error message is shown
    expect(
        find.text('Please approve the terms and conditions'), findsOneWidget);
  });
}

// Helper function to select dropdown values
Future<void> _selectDropdownValue(
  WidgetTester tester,
  String key,
  String value,
) async {
  final dropdown = find.byKey(Key(key));
  await tester.ensureVisible(dropdown);
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text(value).last);
  await tester.pumpAndSettle();
}
