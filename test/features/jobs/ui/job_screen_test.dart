import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/universal_app_bar_widget.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_details_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';

void main() {
  testWidgets('Clicking search field opens JobSearchScreen', (WidgetTester tester) async {
    await tester.pumpWidget(ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            routes: {
              // '/homeScreen': (context) =>
              //     const Scaffold(body: Text('Home Screen')),
              Routes.jobSearchScreen: (context) => JobSearchScreen(),
              Routes.jobListScreen:(context)=>JobListScreen(),
            },
           home: Scaffold(
            appBar: universalAppBar(context,4),
            body:JobListScreen(),
            bottomNavigationBar: UniversalBottomBar(),
           ),
          );
        },
      ),
    );

    // Find the search field and tap it
    final searchField = find.byKey(Key("jobList_search_textField"));
    await tester.tap(searchField);
    await tester.pumpAndSettle();

    // Verify JobSearchScreen is pushed
    expect(find.byType(JobSearchScreen), findsOneWidget);
  });

  testWidgets('Clicking a job card opens JobDetailScreen with correct job details', (WidgetTester tester) async {
    final testJob = Job(
      id: 1,
      title: "Software Engineer",
      industry: "Technology",
      company: Company(name: "TechCorp", size: "500+ employees"),
      description: "Develop and maintain software solutions.",
      workplace: "Hybrid",
      type: "Full-time",
      experienceLevel: "Mid-Level",
      salaryRange: SalaryRange(min: 60000, max: 90000),
      location: Location(city: "San Francisco", country: "USA"),
      keywords: ["Flutter", "Dart", "Backend"],
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: JobList(jobs: [testJob])),
    ));

    // Find and tap the job card
    final jobCard = find.byKey(Key("jobs_openJob_card${testJob.id}"));
    await tester.tap(jobCard);
    await tester.pumpAndSettle();

    // Verify JobDetailScreen is shown
    expect(find.byType(JobDetailScreen), findsOneWidget);
    expect(find.text("Software Engineer"), findsOneWidget);
    expect(find.text("TechCorp"), findsOneWidget);
    expect(find.text("San Francisco, USA"), findsOneWidget);
  });
}
