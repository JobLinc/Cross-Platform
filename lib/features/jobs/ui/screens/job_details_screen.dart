import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_application_screen.dart';

class JobDetailScreen extends StatefulWidget {
  final Job jobDetails;
  final ScrollController scrollController;

  const JobDetailScreen({
    super.key,
    required this.scrollController,
    required this.jobDetails,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  //late List<Job> _savedJobs;
  late List<Job> appliedJobs;
  late List<Job> savedJobs;
  bool? isApplied =false;
  bool? isSaved =false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    //context.read<JobListCubit>().getSavedJobs();
    context.read<JobListCubit>().getJobDetails();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<JobListCubit, JobListState>(
      listener: (context, state) {
        if (state is JobDetailsLoading) {
          setState(() {
            loading = true;
          });
        } else if (state is JobDetailsLoaded) {
          setState(() {
            appliedJobs = state.appliedJobs;
            savedJobs = state.savedJobs;
            isApplied =
                appliedJobs.any((job) => job.id == widget.jobDetails.id);
            isSaved = savedJobs.any((job) => job.id == widget.jobDetails.id);
            loading = false;
          });
        }
      },
      child: Material(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            controller: widget.scrollController,
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                Text(
                  "${widget.jobDetails.company!.name}",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  "${widget.jobDetails.industry} - ${widget.jobDetails.title}",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  " ${widget.jobDetails.location!.city}, ${widget.jobDetails.location!.city}, ${widget.jobDetails.location!.country}",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Reposted ${DateFormat.MMMd().format(widget.jobDetails.createdAt!)} - ${DateFormat.jm().format(widget.jobDetails.createdAt!)}",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  "${widget.jobDetails.company!.size}",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Chip(label: Text("${widget.jobDetails.workplace}")),
                    SizedBox(
                      width: 8.h,
                    ),
                    Chip(label: Text("${widget.jobDetails.type}")),
                  ],
                ),
                SizedBox(height: 16.h),
                if (loading)
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Loading"),
                    ),
                  )
                else
                  BlocBuilder<JobListCubit, JobListState>(
                    builder: (context, state) {
                      if (state is JobDetailsLoading) {
                        return SizedBox(
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red[400], // Dim color when applied
                              foregroundColor: Colors.white,
                            ),
                            child: Text("Loading"),
                          ),
                        );
                      } else if (state is JobAppliedLoaded) {
                          isApplied = state.appliedJobs
                              .any((job) => job.id == widget.jobDetails.id);
                        return SizedBox(
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: isApplied!
                                ? null // Disable button if applied
                                : () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) =>
                                              getIt<JobListCubit>(),
                                          child: JobApplicationScreen(
                                              job: widget.jobDetails),
                                        ),
                                      ),
                                    );
                                    context
                                        .read<JobListCubit>()
                                        .getAppliedJobs();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isApplied!
                                  ? Colors.grey[400]
                                  : Colors.red[400], // Dim color when applied
                              foregroundColor: Colors.white,
                            ),
                            child: Text(isApplied! ? "Applied" : "Apply"),
                          ),
                        );
                      } else {
                          return SizedBox(
                            width: screenWidth * 0.9,
                            child: ElevatedButton(
                              onPressed: isApplied!
                                  ? null // Disable button if applied
                                  : () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) =>
                                                getIt<JobListCubit>(),
                                            child: JobApplicationScreen(
                                                job: widget.jobDetails),
                                          ),
                                        ),
                                      );
                                      await context
                                          .read<JobListCubit>()
                                          .getAppliedJobs();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isApplied!
                                    ? Colors.grey[400]
                                    : Colors.red[400], // Dim color when applied
                                foregroundColor: Colors.white,
                              ),
                              child: Text(isApplied! ? "Applied" : "Apply"),
                            ),
                          );
                      }
                    },
                  ),

                BlocBuilder<JobListCubit, JobListState>(
                  builder: (context, state) {
                    if (state is JobDetailsLoading) {
                      return SizedBox(
                        width: screenWidth * 0.9,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          label: Text(
                            "Loading",
                            style: TextStyle(
                                color: Colors.red[400], fontSize: 16.sp),
                          ),
                          //icon: Icon(Icons.circle, color: Colors.red[400]),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.red[400]!),
                          ),
                        ),
                      );
                    } else if (state is JobSavedLoaded) {
                        isSaved = state.savedJobs
                            .any((job) => job.id == widget.jobDetails.id);
                      return SizedBox(
                        width: screenWidth * 0.9,
                        child: OutlinedButton.icon(
                          onPressed: () async{
                              if (isSaved!) {
                                await context
                                    .read<JobListCubit>()
                                    .unsaveJob(widget.jobDetails.id!);
                              } else {
                                await context
                                    .read<JobListCubit>()
                                    .saveJob(widget.jobDetails.id!);
                              }
                              await context.read<JobListCubit>().getSavedJobs();
                          },
                          icon: isSaved!
                              ? Icon(Icons.check, color: Colors.red[400])
                              : SizedBox.shrink(),
                          label: Text(
                            isSaved! ? "Saved" : "Save",
                            style: TextStyle(
                                color: Colors.red[400], fontSize: 16.sp),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.red[400]!),
                          ),
                        ),
                      );
                    } else {
                        return SizedBox(
                          width: screenWidth * 0.9,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                if (isSaved!) {
                                  context
                                      .read<JobListCubit>()
                                      .unsaveJob(widget.jobDetails.id!);
                                } else {
                                  context
                                      .read<JobListCubit>()
                                      .saveJob(widget.jobDetails.id!);
                                }
                                context.read<JobListCubit>().getSavedJobs();
                              });
                            },
                            icon: isSaved!
                                ? Icon(Icons.check, color: Colors.red[400])
                                : SizedBox.shrink(),
                            label: Text(
                              isSaved! ? "Saved" : "Save",
                              style: TextStyle(
                                  color: Colors.red[400], fontSize: 16.sp),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.red[400]!),
                            ),
                          ),
                        );
                    }
                  },
                ),
                SizedBox(height: 16.h),
                Text(
                  "${widget.jobDetails.description}",
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                //Text("Get AI-powered advice on this job and more exclusive features with Premium."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
