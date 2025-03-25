import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';
import 'package:joblinc/features/companyPages/ui/screens/create_company.dart';
import 'package:joblinc/features/companyPages/ui/widgets/form/submit_company.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateCompanyCubit extends Mock implements CreateCompanyCubit {}

class FakeTextEditingController extends Fake implements TextEditingController {}

void main() {
  late MockCreateCompanyCubit mockCubit;

  setUpAll(() {
    registerFallbackValue(FakeTextEditingController());
  });

  setUp(() {
    mockCubit = MockCreateCompanyCubit();
    when(() => mockCubit.state).thenReturn(CreateCompanyInitial());
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<CreateCompanyCubit>.value(
        value: mockCubit,
        child: child,
      ),
    );
  }

  testWidgets('should show validation error when form is invalid', (tester) async {
    await tester.pumpWidget(createTestWidget(CreateCompanyPage()));

    expect(find.byKey(const Key('createcompany_name_textfield')), findsOneWidget);
    await tester.tap(find.byType(SubmitCompany));
    await tester.pump();

    expect(find.text('Please enter a company name'), findsOneWidget);
  });

  testWidgets('should call createCompany when form is valid', (tester) async {
    when(() => mockCubit.createCompany(
      nameController: any(named: 'nameController'),
      jobLincUrlController: any(named: 'jobLincUrlController'),
      selectedIndustry: any(named: 'selectedIndustry'),
      orgSize: any(named: 'orgSize'),
      orgType: any(named: 'orgType'),
      websiteController: any(named: 'websiteController'),
    )).thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget(CreateCompanyPage()));

    await tester.enterText(find.byKey(const Key('createcompany_name_textfield')), 'Test Company');
    await tester.enterText(find.byKey(const Key('createcompany_jobLincUrl_textfield')), 'test-company');
    await tester.enterText(find.byKey(const Key('createcompany_website_textfield')), 'https://test.com');

    await tester.tap(find.byKey(const Key('createcompany_industry_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Technology').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    await tester.tap(find.byType(SubmitCompany));
    await tester.pumpAndSettle();

    verify(() => mockCubit.createCompany(
      nameController: any(named: 'nameController'),
      jobLincUrlController: any(named: 'jobLincUrlController'),
      selectedIndustry: any(named: 'selectedIndustry'),
      orgSize: any(named: 'orgSize'),
      orgType: any(named: 'orgType'),
      websiteController: any(named: 'websiteController'),
    )).called(1);
  });

  testWidgets('should show error when terms are not accepted', (tester) async {
    await tester.pumpWidget(createTestWidget(CreateCompanyPage()));

    await tester.enterText(find.byKey(const Key('createcompany_name_textfield')), 'Test');
    await tester.tap(find.byType(SubmitCompany));
    await tester.pump();

    expect(find.text('You must accept the terms and conditions'), findsOneWidget);
  });
}
