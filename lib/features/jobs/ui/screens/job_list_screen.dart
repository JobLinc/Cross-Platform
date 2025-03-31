import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/custom_horizontal_pill_bar.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
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
  final searchTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<JobListCubit>().getAllJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHorizontalPillBar(
            changePillColor: false,
            items: ["Preferences", "My Jobs", "Post a free job", "what"],
            onItemSelected: labelClicked),
        Expanded(child: BlocBuilder<JobListCubit, JobListState>(
                builder: (context, state) {
              if (state is JobListLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is JobListEmpty) {
                return Center(child: Text("Save Jobs to see them here "));
              } else if (state is JobListLoaded) {
                return JobList(
                    key: ValueKey(state.jobs!.length),
                    jobs: state.jobs!);
              } else {
                return Center(child: Text("Something went wrong."));
              }
            })),
      ],
    );
  }

  labelClicked(String label){
  if (label=="Preferences"){

  }
  else if (label == "My Jobs"){
    Navigator.pushNamed(context, Routes.myJobsScreen);
  }
  else if(label == "Post a free job"){

  }
  return;
}
}




emptyFunction(String needed) {}


