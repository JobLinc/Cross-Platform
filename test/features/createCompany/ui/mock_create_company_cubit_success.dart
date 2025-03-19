import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/companyPages/ui/widgets/form/submit_company.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/companyPages/ui/screens/create_company.dart';
import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';

// Mock classes
class MockCreateCompanyCubit extends MockCubit<CreateCompanyState>
    implements CreateCompanyCubit {}

class FakeCreateCompanyState extends Fake implements CreateCompanyState {}

class FakeTextEditingController extends Fake implements TextEditingController {}

void main() {
  late MockCreateCompanyCubit mockCreateCompanyCubit;

  setUpAll(() {
    // Register fallback values
    registerFallbackValue(FakeCreateCompanyState());
    registerFallbackValue(FakeTextEditingController());
    registerFallbackValue(
        Industry.technology); // Register an enum value for Industry
    registerFallbackValue(OrganizationSize
        .zeroToOne); // Register an enum value for OrganizationSize
    registerFallbackValue(OrganizationType
        .privatelyHeld); // Register an enum value for OrganizationType
  });

  setUp(() {
    mockCreateCompanyCubit = MockCreateCompanyCubit();
    when(() => mockCreateCompanyCubit.state).thenReturn(CreateCompanyInitial());
  });

  testWidgets('calls createCompany on button tap when form is valid',
      (tester) async {
    // Arrange
    when(() => mockCreateCompanyCubit.createCompany(
          nameController: any(named: 'nameController'),
          jobLincUrlController: any(named: 'jobLincUrlController'),
          selectedIndustry: any(named: 'selectedIndustry'),
          orgSize: any(named: 'orgSize'),
          orgType: any(named: 'orgType'),
          websiteController: any(named: 'websiteController'),
        )).thenAnswer((_) async {});

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
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

    // Act
    await tester.pumpAndSettle(); // Wait for the UI to settle

    // Verify that all components are found
    final nameField = find.byKey(const Key('createcompany_name_textfield'));
    final jobLincUrlField =
        find.byKey(const Key('createcompany_jobLincUrl_textfield'));
    final websiteField =
        find.byKey(const Key('createcompany_website_textfield'));
    final submitButton = find.byType(SubmitCompany);
    final industryDropdown =
        find.byKey(const Key('createcompany_industry_dropdown'));
    final orgSizeDropdown =
        find.byKey(const Key('createcompany_orgSize_dropdown'));
    final orgTypeDropdown =
        find.byKey(const Key('createcompany_orgType_dropdown'));
    final checkbox = find.byType(Checkbox);

    expect(nameField, findsOneWidget);
    expect(jobLincUrlField, findsOneWidget);
    expect(websiteField, findsOneWidget);
    expect(submitButton, findsOneWidget);
    expect(industryDropdown, findsOneWidget);
    expect(orgSizeDropdown, findsOneWidget);
    expect(orgTypeDropdown, findsOneWidget);
    expect(checkbox, findsOneWidget);

    // Enter text into the form fields
    await tester.enterText(nameField, 'Test Company');
    await tester.enterText(jobLincUrlField, 'test-company');
    await tester.enterText(websiteField, 'https://test.com');

    // Simulate selecting values for dropdowns
    await tester.ensureVisible(industryDropdown);
    await tester.tap(industryDropdown);
    await tester.pumpAndSettle(); // Wait for the dropdown menu to appear
    await tester.tap(find
        .text(Industry.technology.displayName)
        .last); // Select a value from the dropdown
    await tester.pumpAndSettle();

    await tester.ensureVisible(orgSizeDropdown);
    await tester.tap(orgSizeDropdown);
    await tester.pumpAndSettle(); // Wait for the dropdown menu to appear
    await tester.tap(find
        .text(OrganizationSize.twoHundredOneToFiveHundred.displayName)
        .last); // Select a value from the dropdown
    await tester.pumpAndSettle();

    await tester.ensureVisible(orgTypeDropdown);
    await tester.tap(orgTypeDropdown);
    await tester.pumpAndSettle(); // Wait for the dropdown menu to appear
    await tester.tap(find
        .text(OrganizationType.privatelyHeld.displayName)
        .last); // Select a value from the dropdown
    await tester.pumpAndSettle();

    // Tick the Terms and Conditions checkbox
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Tap the submit button
    await tester.tap(submitButton);
    await tester.pumpAndSettle(); // Wait for the UI to update

    // Assert
    verify(() => mockCreateCompanyCubit.createCompany(
          nameController: any(named: 'nameController'),
          jobLincUrlController: any(named: 'jobLincUrlController'),
          selectedIndustry: any(named: 'selectedIndustry'),
          orgSize: any(named: 'orgSize'),
          orgType: any(named: 'orgType'),
          websiteController: any(named: 'websiteController'),
        )).called(1);
  });
}
