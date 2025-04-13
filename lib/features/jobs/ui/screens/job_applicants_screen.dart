import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_applicant_card.dart';

class JobApplicantsScreen extends StatefulWidget {
  final Job job;

  const JobApplicantsScreen({Key? key, required this.job}) : super(key: key);

  @override
  _JobApplicantsScreenState createState() => _JobApplicantsScreenState();
}

class _JobApplicantsScreenState extends State<JobApplicantsScreen> {
  @override
  void initState() {
    super.initState();
    // Call getJobApplicants with the job id
    context.read<MyJobsCubit>().getJobApplicants(widget.job.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "${widget.job.title} Applicants",
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<MyJobsCubit, MyJobsState>(
        builder: (context, state) {
          if (state is MyJobApplicantsLoaded) {
            return JobApplicantList(
              key: ValueKey(state.jobApplicants.length),
              jobApplications: state.jobApplicants,
            );
          } else if (state is MyJobsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyJobApplicantsEmpty) {
            return const Center(child: Text("No one has applied yet"));
          } else {
            return const Center(child: Text("Something went wrong"));
          }
        },
      ),
    );
  }
}
