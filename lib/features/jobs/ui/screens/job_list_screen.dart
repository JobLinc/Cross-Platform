import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/custom_horizontal_pill_bar.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_creation_screen.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late List<Job> searchedJobs;
  bool? isSearching = false;
  Map <String,dynamic>? queryParams = {};
  final searchTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    //print("getting jobs");
    context.read<JobListCubit>().getAllJobs(queryParams: queryParams);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHorizontalPillBar(
            changePillColor: false,
            items: [ "My Jobs", "Post a free job",],
            onItemSelected: labelClicked),
        Expanded(child:
            BlocBuilder<JobListCubit, JobListState>(builder: (context, state) {
          if (state is JobListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is JobListEmpty) {
            return Center(child: Text("No jobs here "));
          } else if (state is JobListLoaded) {
            return JobList(
                key: ValueKey(state.jobs!.length), jobs: state.jobs!);
          } else {
            return Center(child: Text("Something went wrong."));
          }
        })),
      ],
    );
  }

  labelClicked(String label) async {
    if (label == "My Jobs") {
      Navigator.pushNamed(context, Routes.myJobsScreen);
    } else if (label == "Post a free job")  {
      final bool created =  await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => BlocProvider(
                    create: (context) => getIt<JobListCubit>(),
                    child: JobCreationScreen(),
                  )));
          if (created == true) {
            // If the job was created successfully, refresh the job list
            // You can use a callback or any other method to trigger the refresh
            // For example, you can call getAllJobs() again here
            context.read<JobListCubit>().getAllJobs(queryParams: queryParams);
          }
    }
    return;
  }
}

emptyFunction(String needed) {}
