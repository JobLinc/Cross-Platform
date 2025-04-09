import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/universal_app_bar_widget.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_details_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';

void main() {
//   void goToJobSearch(BuildContext context){
//   //Navigator.pushNamed(context,Routes.jobSearchScreen);
//  Navigator.of(context, rootNavigator: true).pushNamed(Routes.jobSearchScreen);
//   }
  Future<void> pumpJobListScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            routes: {
              '/homeScreen': (context) =>
                  const Scaffold(body: Text('Home Screen')),
              Routes.jobListScreen: (context) => Scaffold(
                    appBar: universalAppBar(context: context, selectedIndex: 4,searchBarFunction: (){Navigator.pushNamed(context,Routes.jobSearchScreen);}),
                    body: JobListScreen(),
                    bottomNavigationBar: UniversalBottomBar(),
                  ),
              Routes.jobSearchScreen: (context) => JobSearchScreen(),
            },
            initialRoute: Routes.jobListScreen,

          );
        },
      ),
    );
    await tester.pumpAndSettle();
  }

  debugPrint(" Widget tree pumped!");
  group('JobListScreen Widget Tests', () {
    testWidgets('Job List screen opens succesfully',
        (WidgetTester tester) async {
      await pumpJobListScreen(tester);
      expect(find.byType(JobListScreen), findsOneWidget);
      expect (find.byKey(Key("jobList_search_textField")),findsOneWidget);
      expect(find.byType(JobCard),findsWidgets);
    });
  });



  testWidgets('Tapping search bar navigates to JobSearchScreen',
      (WidgetTester tester) async {

    await pumpJobListScreen(tester);
    expect(find.byType(JobListScreen), findsOneWidget);
    expect(find.byType(JobSearchScreen),findsNothing); 

    final searchBar = find.byKey(Key('jobList_search_textField'));
    expect(searchBar, findsOneWidget);

    await tester.tap(searchBar);
    await tester.pumpAndSettle(); // Wait for the navigation to complete

    expect(find.byType(JobSearchScreen), findsOneWidget);
    expect(find.byType(JobListScreen), findsNothing);

    expect(find.byKey(Key("jobSearch_searchByTitle_textField")),findsOneWidget);
    expect(find.byKey(Key("jobSearch_searchByLocation_textField")),findsOneWidget);
  });


  testWidgets('Tapping a job card opens JobdetailsScreen',(WidgetTester tester) async{

    await pumpJobListScreen(tester);

    for (var job in mockJobs) {
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(Key("jobs_openJob_card${job.id}")));
      await tester.pumpAndSettle();
      final jobCard =find.byKey(Key("jobs_openJob_card${job.id}"));
      await tester.tap(jobCard);
      await tester.pumpAndSettle();
      expect(find.byType(DraggableScrollableSheet),findsOneWidget);
      expect(find.byType(JobDetailScreen),findsOneWidget);
      expect(find.text(job.title!),findsAny);
      expect(find.text(job.company!.name!),findsAny);
      await tester.drag(find.byType(DraggableScrollableSheet), Offset(0, 500));
      await tester.pumpAndSettle();
      expect(find.byType(DraggableScrollableSheet), findsNothing);
    }
  });
}
