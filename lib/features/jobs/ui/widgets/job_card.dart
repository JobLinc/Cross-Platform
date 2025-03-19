import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/ui/screens/job_details_screen.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final Function? press;
  const JobCard(
      {super.key, required this.job, this.press, required int itemIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: Key("jobs_openJob_card${job.id}"),
        onTap: () {
          if (press != null) {
            press!();
          }
        },
        // child: ScreenUtilInit(
        //   designSize:
        //       Size(375, 812), // Set based on your design (width, height)
        //   minTextAdapt: true,
        //   splitScreenMode: true,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(job.title!,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Icon(Icons.verified, color: Colors.blue, size: 18),
                        ]),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          job.company!.name!,
                          style:
                              TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${job.location!.country!}, ${job.location!.city!}",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.school,
                                size: 16, color: Colors.grey[700]),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${job.company!.size}",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            )
                          ],
                        ),
                        SizedBox(height: 6),
                        Text("Promoted",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]))
                      ],
                    ),
                  ))),
        );
  }
}

class JobList extends StatelessWidget {
  final List<Job> jobs;

  const JobList({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: ValueKey(jobs.length),
        itemCount: jobs.length,
        itemBuilder: (context, index) => JobCard(
              itemIndex: index,
              job: jobs[index],
              press: () {
                showJobDetails(context, jobs[index]);
                //print("Tapped on: ${sortedChats[index].userName}");
              },
            ));
  }
}

void showJobDetails(BuildContext context, Job jobDetails) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
            key: Key("jobDetails_Screen_draggableScrollableSheet"),
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Material(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: JobDetailScreen(
                    scrollController: scrollController,
                    jobDetails: jobDetails,
                  ));
            });
      });
}
