// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:joblinc/core/routing/routes.dart';
// import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';
// import 'package:joblinc/features/companyPages/ui/screens/create_company.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:joblinc/features/companyPages/data/data/company.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:joblinc/features/companyPages/data/data/repos/createcompany_repo.dart';

// class MockCreateCompanyRepo extends Mock implements CreateCompanyRepo {}
// class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// void main() {
//   late MockCreateCompanyRepo mockRepo;
//   late MockNavigatorObserver mockObserver;
//   late CreateCompanyCubit cubit;
//   late Company createdCompany;

//   setUpAll(() {
//     registerFallbackValue(FakeTextEditingController());
//     registerFallbackValue(Industry.technology);
//     registerFallbackValue(OrganizationSize.twoToTen);
//     registerFallbackValue(OrganizationType.privatelyHeld);
//   });

//   setUp(() {
//     mockRepo = MockCreateCompanyRepo();
//     mockObserver = MockNavigatorObserver();
    
//     cubit = CreateCompanyCubit(
//       mockRepo,
//       onCompanyCreated: (company) {
//         createdCompany = company;
//       },
//     );

//     // Mock the repo method
//     when(() => mockRepo.createCompany(
//       any(),
//       any(),
//       any(),
//       any(),
//       any(),
//     )).thenAnswer((_) async {});
//   });

//   tearDown(() {
//     cubit.close();
//   });

//   Widget createTestWidget() {
//     return ScreenUtilInit(
//       designSize: const Size(412, 924),
//       minTextAdapt: true,
//       builder: (context, child) {
//         return MaterialApp(
//           home: BlocProvider<CreateCompanyCubit>.value(
//             value: cubit,
//             child: CreateCompanyPage(),
//           ),
//           navigatorObservers: [mockObserver],
//           onGenerateRoute: (settings) {
//             if (settings.name == Routes.companyDashboard) {
//               return MaterialPageRoute(
//                 builder: (_) => Scaffold(
//                   body: Center(child: Text('Company Dashboard')),
//                 ),
//                 settings: settings,
//               );
//             }
//             return null;
//           },
//         );
//       },
//     );
//   }

//   testWidgets('should show validation error when form is invalid', (tester) async {
//     await tester.pumpWidget(createTestWidget());
//     await tester.pumpAndSettle();

//     final submitButton = find.byKey(Key("createcompany_submit_button"));
//     expect(submitButton, findsOneWidget);
//     await tester.tap(submitButton);
//     await tester.pump();

//     // Verify validation errors
//     expect(find.text('Please enter a name'), findsOneWidget);
//   });

//   testWidgets('should not create company when terms checkbox is not ticked', (tester) async {
//     await tester.pumpWidget(createTestWidget());
//     await tester.pumpAndSettle();

//     // Fill out the form but don't check the terms checkbox
//     await tester.enterText(
//       find.byKey(const Key('createcompany_name_textfield')),
//       'Test Company',
//     );
//     await tester.enterText(
//       find.byKey(const Key('createcompany_jobLincUrl_textfield')),
//       'test-company',
//     );
//     await tester.enterText(
//       find.byKey(const Key('createcompany_website_textfield')),
//       'https://test.com',
//     );

//     // Submit form without checking terms
//     await tester.tap(find.byKey(Key("createcompany_submit_button")));
//     await tester.pump();

//     // // Verify the repo method was NOT called
//     // verifyNever(() => mockRepo.createCompany(
//     //   any(),
//     //   any(),
//     //   any(),
//     //   any(),
//     //   any(),
//     // ));

//     expect(find.text('Please approve terms and conditions'), findsOneWidget);
//   });

//   testWidgets('should create company and trigger callback when form is valid', (tester) async {
//     await tester.pumpWidget(createTestWidget());
//     await tester.pumpAndSettle();

//     // Fill out the form completely
//     await tester.enterText(
//       find.byKey(const Key('createcompany_name_textfield')),
//       'Test Company',
//     );
//     await tester.enterText(
//       find.byKey(const Key('createcompany_jobLincUrl_textfield')),
//       'test-company',
//     );
//     await tester.enterText(
//       find.byKey(const Key('createcompany_website_textfield')),
//       'https://test.com',
//     );

//     // Accept terms
//     await tester.tap(find.byKey(const Key('createcompany_terms_checkbox')));
//     await tester.pump();

//     // Submit form
//     await tester.tap(find.byKey(Key("createcompany_submit_button")));
//     await tester.pumpAndSettle();

//     // Verify the repo method was called
//     verify(() => mockRepo.createCompany(
//       'Test Company',
//       'ohhhddoohpo@gmail.com',
//       '1234785432139788212734567876547',
//       any(),
//       'overview',
//     )).called(1);

//     // Verify the callback was triggered
//     expect(createdCompany.name, 'Test Company');
//     expect(createdCompany.profileUrl, 'test-company');
//     expect(createdCompany.website, 'https://test.com');
//   });
// }

// class FakeTextEditingController extends Fake implements TextEditingController {}