import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:joblinc/features/companyPages/ui/screens/create_company.dart';
import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';

class MockCreateCompanyCubit extends MockCubit<CreateCompanyState> implements CreateCompanyCubit {}

void main() {
  late MockCreateCompanyCubit mockCreateCompanyCubit;

  setUp(() {
    mockCreateCompanyCubit = MockCreateCompanyCubit();
  });

  tearDown(() {
    mockCreateCompanyCubit.close();
  });

  testWidgets('CreateCompanyPage form submission', (WidgetTester tester) async {
    whenListen(
      mockCreateCompanyCubit,
      Stream.fromIterable([CreateCompanyInitial(), CreateCompanySuccess()]),
      initialState: CreateCompanyInitial(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CreateCompanyCubit>(
          create: (_) => mockCreateCompanyCubit,
          child: CreateCompanyPage(),
        ),
      ),
    );

    // Ensure all widgets are found before interacting with them
    final nameField = find.byKey(Key('createcompany_name_textfield'));
    final jobLincUrlField = find.byKey(Key('createcompany_jobLincUrl_textfield'));
    final websiteField = find.byKey(Key('createcompany_website_textfield'));
    final industryDropdown = find.byKey(Key('createcompany_industry_dropdown'));
    final orgSizeDropdown = find.byKey(Key('createcompany_orgSize_dropdown'));
    final orgTypeDropdown = find.byKey(Key('createcompany_orgType_dropdown'));
    final termsCheckBox = find.byKey(Key('termsAndConditionsCheckBox'));
    final submitButton = find.byKey(Key('createcompany_submit_button'));

    expect(nameField, findsOneWidget, reason: "Name field not found");
    expect(jobLincUrlField, findsOneWidget, reason: "JobLinc URL field not found");
    expect(websiteField, findsOneWidget, reason: "Website field not found");
    expect(industryDropdown, findsOneWidget, reason: "Industry dropdown not found");
    expect(orgSizeDropdown, findsOneWidget, reason: "Org size dropdown not found");
    expect(orgTypeDropdown, findsOneWidget, reason: "Org type dropdown not found");
    expect(termsCheckBox, findsOneWidget, reason: "Terms checkbox not found");
    expect(submitButton, findsOneWidget, reason: "Submit button not found");

    // Fill out the form fields
    await tester.enterText(nameField, 'Test Company');
    await tester.enterText(jobLincUrlField, 'test-joblinc-url');
    await tester.enterText(websiteField, 'https://test.com');
    
    // Select dropdowns
    await tester.tap(industryDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Information Services').last);
    await tester.pumpAndSettle();
    
    await tester.tap(orgSizeDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Large').last);
    await tester.pumpAndSettle();
    
    await tester.tap(orgTypeDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Public').last);
    await tester.pumpAndSettle();

    // Check terms and conditions
    await tester.tap(termsCheckBox);
    await tester.pumpAndSettle();

    // Trigger form submission
    await tester.tap(submitButton);
    await tester.pump();

    // Verify that the form submission was triggered
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