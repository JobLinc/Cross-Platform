import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/widgets/custom_horizontal_pill_bar.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_application_card.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  String selected = "saved";
  final auth = getIt<AuthService>();
  late final String userId;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
    context.read<MyJobsCubit>().getSavedJobs();
  }

  Future<void> _initializeUserId() async {
    userId = await auth.getUserId() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Jobs"),
        ),
        body: Column(
          children: [
            CustomHorizontalPillBar(
                selectedLabel: "Saved",
                items: [
                  "Saved",
                  "Applied",
                  "Created",
                  "Job Applications",
                ],
                onItemSelected: labelClicked),
            Expanded(child: BlocBuilder<MyJobsCubit, MyJobsState>(
                builder: (context, state) {
              if (state is MyJobsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MySavedJobsEmpty) {
                return Center(child: Text("Save Jobs to see them here "));
              } else if (state is MyAppliedJobsEmpty) {
                return Center(child: Text("Apply to Jobs to see them here "));
              } else if (state is MyCreatedJobsEmpty) {
                return Center(child: Text("Create Jobs to see them here "));
              } else if (state is MyJobApplicationsEmpty) {
                return Center(child:Text("Apply to Jobs to see your Applications here "));
              } else if (state is MySavedJobsLoaded) {
                return JobList(
                  semanticsLabel: "Saved Jobs",
                    key: ValueKey(state.savedJobs.length),
                    jobs: state.savedJobs,
                    savedPage: true,);
              } else if (state is MyAppliedJobsLoaded) {
                return JobList(
                    semanticsLabel: "Applied Jobs",
                    key: ValueKey(state.appliedJobs.length),
                    jobs: state.appliedJobs);
              } else if (state is MyCreatedJobsLoaded) {
                return JobList(
                    semanticsLabel: "Created Jobs",
                    key: ValueKey(state.createdJobs.length),
                    jobs: state.createdJobs,
                    isCreated: true,);
              } else if (state is MyJobApplicationsLoaded) {
                return JobApplicationList(
                    key: ValueKey(state.jobApplications.length),
                    jobApplications: state.jobApplications);
              } else {
                return Center(child: Text("Something went wrong."));
              }
            })),
          ],
        ));
  }

  labelClicked(String label) {
    setState(() {
      if (label == "Saved") {
        context.read<MyJobsCubit>().getSavedJobs();
      } else if (label == "Applied") {
        context.read<MyJobsCubit>().getAppliedJobs();
      } else if (label == "Job Applications") {
        context.read<MyJobsCubit>().getJobApplications();
      } else if (label == "Created") {
        context.read<MyJobsCubit>().getCreatedJobs(userId);
      }
    });
    return;
  }
}
