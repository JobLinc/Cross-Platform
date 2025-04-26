// import 'dart:io';

// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:joblinc/core/routing/routes.dart';
// import 'package:joblinc/core/widgets/universal_app_bar_widget.dart';
// import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
// import 'package:joblinc/features/home/ui/screens/home_screen.dart';
// import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
// import 'package:joblinc/features/jobs/ui/screens/job_application_screen.dart';
// import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
// import 'package:joblinc/features/jobs/ui/screens/job_details_screen.dart';
// import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';
// import 'package:joblinc/features/jobs/data/models/job_model.dart';
// import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';
// import 'package:mocktail/mocktail.dart';

// // void _onItemTapped(int index) {
// //   setState(() {
// //     _selectedIndex = index;
// //     _tabController.animateTo(index);
// //   });//   void goToJobSearch(BuildContext context){
// //   //Navigator.pushNamed(context,Routes.jobSearchScreen);
// //  Navigator.of(context, rootNavigator: true).pushNamed(Routes.jobSearchScreen);
// //   }

// class MockJobListCubit extends MockCubit<JobListState>
//     implements JobListCubit {
//   List<Job> jobs = [];
// }
// class FakeJobListState extends Fake implements JobListState {}

// class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// class _NoHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? _) =>
//       super.createHttpClient(_)
//         ..badCertificateCallback =
//             (X509Certificate cert, String host, int port) => true;
// }
// void main() {
//   late MockJobListCubit mockCubit;
//   late MockNavigatorObserver mockObserver;


//   setUpAll(() {
//     // required by mockito for any unstubbed ChatListState
//     HttpOverrides.global = _NoHttpOverrides();
//     registerFallbackValue(FakeJobListState());
//   });

//   setUp(() {
//     mockCubit = MockJobListCubit();
//     mockObserver = MockNavigatorObserver();

//     // stub the initial fetch
//     when(() => mockCubit.getAllJobs()) // or getAllChats, rename if needed
//         .thenAnswer((_) async {});
//   });

//   tearDown(() async {
//     await mockCubit.close();
//   });


//   Future<void> pumpJobListScreen(WidgetTester tester) async {
//     await tester.pumpWidget(
//       ScreenUtilInit(
//         designSize: Size(412, 924),
//         minTextAdapt: true,
//         builder: (context, child) {
//           return MaterialApp(
//             routes: {
//               Routes.jobListScreen: (context) => BlocProvider(
//                     create: (_) => mockCubit,
//                     child: Scaffold(
//                       // appBar: universalAppBar(
//                       //     context: context,
//                       //     selectedIndex: 4,
//                       //     searchBarFunction: () {
//                       //       Navigator.pushNamed(
//                       //           context, Routes.jobSearchScreen);
//                       //     }),
//                       body: JobListScreen(),
//                       // bottomNavigationBar: UniversalBottomBar(
//                       //   currentIndex: 4,
//                       //   onTap: (index) {
//                       //     if (index == 4) {
//                       //       Navigator.pushNamed(context, Routes.jobListScreen);
//                       //     } else {
//                       //       Navigator.pushNamed(context, Routes.homeScreen);
//                       //     }
//                       //   },
//                       // ),
//                     ),
//                   ),
//               Routes.jobSearchScreen: (context) => JobSearchScreen(),
//             },
//             initialRoute: Routes.jobListScreen,
//           );
//         },
//       ),
//     );
//     await tester.pumpAndSettle();
//   }

//   debugPrint(" Widget tree pumped!");
//   group('JobListScreen Widget Tests', () {
//     testWidgets('Job List screen opens succesfully',
//         (WidgetTester tester) async {
//       await pumpJobListScreen(tester);
//       expect(find.byType(JobListScreen), findsOneWidget);
//       expect(find.byKey(Key("jobList_search_textField")), findsOneWidget);
//       expect(find.byType(JobCard), findsWidgets);
//     });
//   });

//   testWidgets('Tapping search bar navigates to JobSearchScreen',
//       (WidgetTester tester) async {
//     await pumpJobListScreen(tester);
//     expect(find.byType(JobListScreen), findsOneWidget);
//     expect(find.byType(JobSearchScreen), findsNothing);

//     final searchBar = find.byKey(Key('jobList_search_textField'));
//     expect(searchBar, findsOneWidget);

//     await tester.tap(searchBar);
//     await tester.pumpAndSettle(); // Wait for the navigation to complete

//     expect(find.byType(JobSearchScreen), findsOneWidget);
//     expect(find.byType(JobListScreen), findsNothing);

//     expect(
//         find.byKey(Key("jobSearch_searchByTitle_textField")), findsOneWidget);
//     expect(find.byKey(Key("jobSearch_searchByLocation_textField")),
//         findsOneWidget);
//   });

//   testWidgets('Tapping a job card opens JobDetailsScreen',
//       (WidgetTester tester) async {
//     await pumpJobListScreen(tester);

//     for (var job in mockJobs) {
//       await tester.pumpAndSettle();
//       await tester.ensureVisible(find.byKey(Key("jobs_openJob_card${job.id}")));
//       await tester.pumpAndSettle();
//       final jobCard = find.byKey(Key("jobs_openJob_card${job.id}"));
//       await tester.tap(jobCard);
//       await tester.pumpAndSettle();
//       expect(find.byType(DraggableScrollableSheet), findsOneWidget);
//       expect(find.byType(JobDetailScreen), findsOneWidget);
//       expect(find.text(job.title!), findsAny);
//       expect(find.text(job.company!.name!), findsAny);
//       await tester.drag(find.byType(DraggableScrollableSheet), Offset(0, 500));
//       await tester.pumpAndSettle();
//       expect(find.byType(DraggableScrollableSheet), findsNothing);
//     }
//   });
// }


import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/universal_app_bar_widget.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_details_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';
//import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart';                   // Your routing constants
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ---------------- MOCKS ------------------

class MockJobListCubit extends MockCubit<JobListState> implements JobListCubit {
  @override
  Future<void> getAllJobs() async {} // Required method
}

class FakeJobListState extends Fake implements JobListState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class _NoHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? _) =>
      super.createHttpClient(_)
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
}

// ---------------- TESTS ------------------

void main() {
  late MockJobListCubit mockCubit;
  late MockNavigatorObserver mockObserver;

  final sampleCompany = Company(name: 'ACME', size: '100-500');
  final sampleSalary = SalaryRange(min: 50.0, max: 100.0);
  final sampleLocation = Location(city: 'New York', country: 'USA');
  final sampleJob = Job(
    id: 'j1',
    title: 'Flutter Developer',
    industry: 'Tech',
    company: sampleCompany,
    description: 'Build apps',
    workplace: 'Remote',
    type: 'Full-time',
    experienceLevel: 'Mid',
    salaryRange: sampleSalary,
    location: sampleLocation,
    keywords: ['flutter', 'dart'],
    createdAt: DateTime.now(),
  );

  final sampleApplicant = Applicant(
    id: 'u1',
    firstname: 'John',
    lastname: 'Doe',
    username: 'johnd',
    email: 'john@example.com',
    country: 'USA',
    city: 'NY',
    phoneNumber: '+1234567890',
  );

  final sampleResume = Resume(
    id: 'r1',
    url: 'https://example.com/cv.pdf',
    date: DateTime.now(),
    size: 12345,
    name: 'cv',
    extension: '.pdf',
  );

  final sampleApplication = JobApplication(
    applicant: sampleApplicant,
    job: sampleJob,
    resume: sampleResume,
    createdAt: DateTime.now(),
  );

  List<Job> mockJobs = [
    sampleJob
    //Job(id: 1, title: 'Flutter Developer', company: Company(name: 'Company A')),
    //Job(id: 2, title: 'Backend Engineer', company: Company(name: 'Company B')),
  ];

  setUpAll(() {
    HttpOverrides.global = _NoHttpOverrides();
    registerFallbackValue(FakeJobListState());
  });

  setUp(() {
    mockCubit = MockJobListCubit();
    mockObserver = MockNavigatorObserver();

    when(() => mockCubit.state).thenReturn(JobListLoaded(jobs: mockJobs));
    when(() => mockCubit.getAllJobs()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockCubit.close();
  });

  Future<void> pumpJobListScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorObservers: [mockObserver],
            routes: {
              '/homeScreen': (context) =>
                  const Scaffold(body: Text('Home Screen')),
              Routes.jobListScreen: (context) => Scaffold(
                    appBar: universalAppBar(context: context, selectedIndex: 4,searchBarFunction: (){Navigator.pushNamed(context,Routes.jobSearchScreen);}),
                    body: JobListScreen(),
                  ),
              Routes.jobSearchScreen: (context) => const JobSearchScreen(),
            },
            initialRoute: Routes.jobListScreen,
          );
        },
      ),
    );
    await tester.pumpAndSettle();
  }

  group('JobListScreen Widget Tests', () {
    testWidgets('Job List screen opens successfully',
        (WidgetTester tester) async {
      await pumpJobListScreen(tester);
      expect(find.byType(JobListScreen), findsOneWidget);
      expect(find.byKey(const Key("jobList_search_textField")), findsOneWidget);
      expect(find.byType(JobCard), findsWidgets);
    });

    testWidgets('Tapping search bar navigates to JobSearchScreen',
        (WidgetTester tester) async {
      await pumpJobListScreen(tester);
      expect(find.byType(JobListScreen), findsOneWidget);
      expect(find.byType(JobSearchScreen), findsNothing);

      final searchBar = find.byKey(const Key('jobList_search_textField'));
      expect(searchBar, findsOneWidget);

      await tester.tap(searchBar);
      await tester.pumpAndSettle();

      expect(find.byType(JobSearchScreen), findsOneWidget);
      expect(find.byType(JobListScreen), findsNothing);
      expect(find.byKey(const Key("jobSearch_searchByTitle_textField")),
          findsOneWidget);
      expect(find.byKey(const Key("jobSearch_searchByLocation_textField")),
          findsOneWidget);
    });

    testWidgets('Tapping a job card opens JobDetailsScreen',
        (WidgetTester tester) async {
      await pumpJobListScreen(tester);

      for (var job in mockJobs) {
        await tester.pumpAndSettle();
        final jobCardKey = Key("jobs_openJob_card${job.id}");
        await tester.ensureVisible(find.byKey(jobCardKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(jobCardKey));
        await tester.pumpAndSettle();

        expect(find.byType(DraggableScrollableSheet), findsOneWidget);
        expect(find.byType(JobDetailScreen), findsOneWidget);
        expect(find.text(job.title!), findsWidgets);
        expect(find.text(job.company!.name!), findsWidgets);

        await tester.drag(find.byType(DraggableScrollableSheet), const Offset(0, 500));
        await tester.pumpAndSettle();

        expect(find.byType(DraggableScrollableSheet), findsNothing);
      }
    });
  });
}
