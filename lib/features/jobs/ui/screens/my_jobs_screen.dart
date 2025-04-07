import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/widgets/custom_horizontal_pill_bar.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  String selected = "saved";

  @override
  void initState() {
    super.initState();
    context.read<MyJobsCubit>().getSavedJobs();
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
                items: ["Saved", "Applied", "In Progress", "Archived"],
                onItemSelected: labelClicked),
            Expanded(child: BlocBuilder<MyJobsCubit, MyJobsState>(
                builder: (context, state) {
              if (state is MyJobsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MySavedJobsEmpty) {
                return Center(child: Text("Save Jobs to see them here "));
              } else if (state is MyAppliedJobsEmpty) {
                return Center(child: Text("Apply to Jobs to see them here "));
              } else if (state is MySavedJobsLoaded) {
                return JobList(
                    key: ValueKey(state.savedJobs!.length),
                    jobs: state.savedJobs!);
              } else if (state is MyAppliedJobsLoaded) {
                return JobList(
                    key: ValueKey(state.appliedJobs!.length),
                    jobs: state.appliedJobs!);
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
      } else if (label == "In Progress") {
      } else if (label == "Archived") {}
    });
    return;
  }
}
