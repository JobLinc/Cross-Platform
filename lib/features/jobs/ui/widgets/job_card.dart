import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/companypages/data/data/models/company_id.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_applicants_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_details_screen.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final bool savedPage;
  final bool isCompanyPageAdmin;
  final String semanticsLabel;
  //final VoidCallback? press;
  JobCard({
    required this.semanticsLabel,
    super.key,
    required this.job,
    this.isCompanyPageAdmin = false,
    this.savedPage = false,
    required int itemIndex,
  });

  final auth = getIt<AuthService>();

  // String? userId;
  @override
  // void initState() {
  //   super.initState();
  //   _initializeUserId();
  // }

  @override
  Widget build(BuildContext context) {
    // decide which “owner” we have
    final hasCompany = job.company != null;

    final ownerName = hasCompany
        ? job.company!.name
        : "${job.employer!.firstname} ${job.employer!.lastname}";
    final ownerSubtitle =
        hasCompany ? job.company!.size : job.employer!.username;
    final ownerAvatar =
        hasCompany ? job.company!.logo : job.employer!.profilePicture;
    onAvatarTap() async {
      if (hasCompany) {
        print("Company ID: ${job.company!.id}");
        Navigator.pushNamed(context, Routes.companyPageHome,
            arguments: job.company!.id);
      } else {
        // e.g. navigate to an employer-profile screen
        final auth = getIt<AuthService>();
        final userId = await auth.getUserId();
        if (userId == job.employer!.id) {
          Navigator.pushNamed(context, Routes.profileScreen);
        } else {
          Navigator.pushNamed(context, Routes.otherProfileScreen,
              arguments: job.employer!.id);
        }

        // Navigator.pushNamed(context, Routes.otherProfileScreen,
        //     arguments: job.employer!.id);
      }
    }

    // Format salary
    final salaryText = "${job.salaryRange.currency} "
        "${job.salaryRange.min.toStringAsFixed(0)}–"
        "${job.salaryRange.max.toStringAsFixed(0)}";

    return FutureBuilder<String?>(
        future: auth.getUserId(),
        builder: (context, snap) {
          final userId = snap.data ?? '';
          final hasCompany = job.company != null;
          final ownerId = hasCompany ? job.company!.id : job.employer!.id;
          final isCreated = (!hasCompany && ownerId == userId) ||
              isCompanyPageAdmin; //hasCompany && MyCompanyIds.instance.companyIds.contains(job.company!.id) ;
          return Semantics(
            label: semanticsLabel,
            container: true,
            child: GestureDetector(
              key: Key("jobs_openJob_card${job.id}"),
              onTap: () {
                showJobDetails(context, job, savedPage, isCreated: isCreated);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 2.h,
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // owner avatar
                        GestureDetector(
                          onTap: onAvatarTap,
                          child: Semantics(
                            label: "Owner avatar",
                            child: CircleAvatar(
                              radius: 40.r,
                              backgroundImage: NetworkImage(ownerAvatar),
                              backgroundColor: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // title row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Semantics(
                                      label: "Job title: ${job.title}",
                                      child: Text(
                                        job.title,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Semantics(
                                    label: "Verified job",
                                    child: Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                      size: 18.r,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              // owner name
                              Semantics(
                                label: "Company or employer name: $ownerName",
                                child: Text(
                                  ownerName,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              // owner subtitle (size or username)
                              Semantics(
                                label: hasCompany
                                    ? "Company size: $ownerSubtitle"
                                    : "Username: $ownerSubtitle",
                                child: Text(
                                  ownerSubtitle,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              // location
                              Semantics(
                                label:
                                    "Location: ${job.location.country}, ${job.location.city}",
                                child: Text(
                                  "${job.location.country}, ${job.location.city}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              // experience & salary
                              Row(
                                children: [
                                  Semantics(
                                    label:
                                        "Experience level: ${job.experienceLevel}",
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                      child: Text(
                                        job.experienceLevel,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxWidth: 120.w),
                                    child: Semantics(
                                      label: "Salary range: $salaryText",
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          salaryText,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.green,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class JobList extends StatelessWidget {
  final List<Job> jobs;
  final bool isCreated;
  final bool savedPage;
  final bool isCompanyPageAdmin;
  final String semanticsLabel;

  const JobList(
      {super.key,
      required this.jobs,
      this.isCreated = false,
      this.savedPage = false,
      this.isCompanyPageAdmin = false,
      required this.semanticsLabel});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      container: true,
      child: Container(
        color: Colors.white70,
        child: ListView.builder(
            key: ValueKey(jobs.length),
            shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) => JobCard(
                  semanticsLabel: "job_card_${jobs[index].id}",
                  itemIndex: index,
                  job: jobs[index],
                  savedPage: savedPage,
                  isCompanyPageAdmin: isCompanyPageAdmin,
                )),
      ),
    );
  }
}

void showJobDetails(BuildContext context, Job jobDetails, bool savedPage,
    {bool isCreated = false}) {
  showModalBottomSheet<bool>(
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
                  child: BlocProvider(
                    create: (context) => getIt<JobListCubit>(),
                    child: JobDetailScreen(
                      scrollController: scrollController,
                      jobDetails: jobDetails,
                      savedPage: savedPage,
                      isCreated: isCreated,
                    ),
                  ));
            });
      }).then((didUnsave) {
    if (didUnsave == true) {
      context.read<MyJobsCubit>().getSavedJobs();
    }
  });
}
