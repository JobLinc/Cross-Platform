import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class JobApplicantCard extends StatefulWidget {
  final JobApplication jobApplication;
  final VoidCallback? onTap;
  // Removed onAccept and onReject since we handle them directly

  const JobApplicantCard({
    Key? key,
    required this.jobApplication,
    this.onTap,
  }) : super(key: key);

  @override
  State<JobApplicantCard> createState() => _JobApplicantCardState();
}

class _JobApplicantCardState extends State<JobApplicantCard> {
  String status = "";
  late JobApplication jobApp;
  @override
  void initState() {
    super.initState();
    // Fetch the latest job applicant data for this card
    // context.read<MyJobsCubit>().getJobApplicantById(
    //       widget.jobApplication.job.id!,
    //       widget.jobApplication.applicant.id,
    //     );
    context.read<MyJobsCubit>().emitMyJobApplicantLoaded(widget.jobApplication);

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Colors.red, width: 2),
      ),
      elevation: 5,
      shadowColor: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Applicant info and picture
            GestureDetector(
              onTap: widget.onTap,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      widget.jobApplication.applicant.firstname[0] +
                          widget.jobApplication.applicant.lastname[0],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.jobApplication.applicant.firstname} ${widget.jobApplication.applicant.lastname}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.jobApplication.applicant.email,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            buildResumeCard(context, widget.jobApplication.resume),
            SizedBox(height: 12.h),
            BlocBuilder<MyJobsCubit, MyJobsState>(
              builder: (context, state) {
                if (state is MyJobApplicantLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MyJobApplicantLoaded) {
                  status = state.jobApplicant.status;
                  jobApp =state.jobApplicant;
                  print(status);
                  if (status == "Pending" || status == "Viewed") {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await context.read<MyJobsCubit>().acceptJobApplication(
                                    jobApp.job.id!,
                                    jobApp.applicant.id,
                                  );
                              context.read<MyJobsCubit>().getJobApplicantById(
                                    jobApp.job.id!,
                                    jobApp.applicant.id,
                                  );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: Text("Accept" ,style: TextStyle(color: ColorsManager.getTextPrimary(context),),)
                          ),
                        ),
                        SizedBox(width: 100.w,),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await context.read<MyJobsCubit>().rejectJobApplication(
                                    jobApp.job.id!,
                                    jobApp.applicant.id,
                                  );
                              context.read<MyJobsCubit>().getJobApplicantById(
                                    jobApp.job.id!,
                                    jobApp.applicant.id,
                                  );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: Text("Reject",style: TextStyle(color: ColorsManager.getTextPrimary(context),),),
                          ),
                        ),
                      ],
                    );
                  } else if (status == "Rejected") {
                    return SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            "Applicant has been Rejected",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (status == "Accepted") {
                    return SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            "Applicant has been Accepted",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text("Something went wrong"));
                  }
                } else {
                  if (status == "Pending" || status == "Viewed") {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await context.read<MyJobsCubit>().acceptJobApplication(
                                    jobApp.job.id!,
                                    jobApp.applicant.id,
                                  );
                              await context.read<MyJobsCubit>().getJobApplicantById(
                                    jobApp.job.id!,
                                    jobApp.applicant.id,
                                  );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: Text("Accept" ,style: TextStyle(color: ColorsManager.getTextPrimary(context),),)
                          ),
                        ),
                        SizedBox(width: 100.w,),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await context.read<MyJobsCubit>().rejectJobApplication(
                                    jobApp.job.id!,
                                    jobApp.applicant.id,
                                  );
                              await context.read<MyJobsCubit>().getJobApplicantById(
                                    jobApp.job.id!,
                                    jobApp.applicant.id,
                                  );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: Text("Reject",style: TextStyle(color: ColorsManager.getTextPrimary(context),),),
                          ),
                        ),
                      ],
                    );
                  } else if (status == "Rejected") {
                    return SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            "Applicant has been Rejected",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (status == "Accepted") {
                    return SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            "Applicant has been Accepted",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text("Something went wrong"));
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _openResume(
      BuildContext context, String resumeUrl, String resumeName) async {
    final directory = await getApplicationDocumentsDirectory();
    final localPath = '${directory.path}/$resumeName';
    final file = File(localPath);

    if (await file.exists()) {
      await OpenFile.open(localPath);
    } else if (await canLaunchUrl(Uri.parse(resumeUrl))) {
      await launchUrl(Uri.parse(resumeUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open resume.")),
      );
    }
  }

  Widget buildResumeCard(BuildContext context, Resume resume) {
    return GestureDetector(
      onTap: () => _openResume(context, resume.url, resume.name),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.red.shade400),
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.all(8.w),
        child: Row(
          children: [
            // Extension badge
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                resume.extension.replaceAll('.', '').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Resume name, size, date info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resume.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${(resume.size / 1024.0).toStringAsFixed(1)} kB - Last updated on ${DateFormat('M/d/yyyy').format(resume.date)}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class JobApplicantList extends StatelessWidget {
//   final List<JobApplication> jobApplications;

//   const JobApplicantList({
//     Key? key,
//     required this.jobApplications,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white70,
//       child: ListView.builder(
//         itemCount: jobApplications.length,
//         itemBuilder: (context, index) {
//           final jobApp = jobApplications[index];
//           return JobApplicantCard(
//             jobApplication: jobApp,
//           );
//         },
//       ),
//     );
//   }
// }













// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:joblinc/core/di/dependency_injection.dart';
// import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
// import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
// import 'package:open_file/open_file.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:path_provider/path_provider.dart';

// class JobApplicantCard extends StatefulWidget {
//   JobApplication jobApplication;
//   final VoidCallback? onTap;
//   // final VoidCallback onAccept;
//   // final VoidCallback onReject;

//   JobApplicantCard({
//     Key? key,
//     required this.jobApplication,
//     this.onTap,
//     //required this.onAccept,
//     //required this.onReject,
//   }) : super(key: key);

//   @override
//   State<JobApplicantCard> createState() => _JobApplicantCardState();
// }

// class _JobApplicantCardState extends State<JobApplicantCard> {
//   JobApplication? jobApplicant;
//   @override
//   void initState() {
//     super.initState();
//     context.read<MyJobsCubit>().getJobApplicantById(
//         widget.jobApplication.job.id!, widget.jobApplication.applicant.id);
//     jobApplicant = widget.jobApplication;
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//         side: BorderSide(color: Colors.red, width: 2),
//       ),
//       elevation: 5,
//       shadowColor: Colors.redAccent,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: widget.onTap,
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.grey[300],
//                     child: Text(
//                       widget.jobApplication.applicant.firstname[0] +
//                           widget.jobApplication.applicant.lastname[0],
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${widget.jobApplication.applicant.firstname} ${widget.jobApplication.applicant.lastname}",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Text(widget.jobApplication.applicant.email,
//                           style: TextStyle(color: Colors.grey[700])),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 12.h),
//             buildResumeCard(context, widget.jobApplication.resume),
//             SizedBox(height: 12.h),
//             BlocBuilder<MyJobsCubit, MyJobsState>(
//               builder: (context, state) {
//                 if (state is MyJobApplicantLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (state is MyJobApplicantLoaded) {
//                   setState(() {
//                     jobApplicant = state.jobApplicant;
//                   });
//                                   if (jobApplicant!.status == "Pending" ||
//                     jobApplicant!.status == "Viewed") {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () async {
//                           await context
//                               .read<MyJobsCubit>()
//                               .acceptJobApplication(jobApplicant!.job.id!,
//                                   jobApplicant!.applicant.id);
//                           context.read<MyJobsCubit>().getJobApplicantById(
//                               jobApplicant!.job.id!,
//                               jobApplicant!.applicant.id);
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green),
//                         child: Text("Accept"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           await context
//                               .read<MyJobsCubit>()
//                               .rejectJobApplication(jobApplicant!.job.id!,
//                                   jobApplicant!.applicant.id);
//                           context.read<MyJobsCubit>().getJobApplicantById(
//                               jobApplicant!.job.id!,
//                               jobApplicant!.applicant.id);
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red),
//                         child: Text("Reject"),
//                       ),
//                     ],
//                   );
//                 } else if (jobApplicant!.status == "Rejected") {
//                   return SizedBox(
//                     width: double.infinity,
//                     child: Container(
//                       padding: EdgeInsets.all(8.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.red, width: 2),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Applicant has been Rejected",
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return SizedBox(
//                     width: double.infinity,
//                     child: Container(
//                       padding: EdgeInsets.all(8.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.green, width: 2),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Applicant has been Accepted",
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 }
//                 if (jobApplicant!.status == "Pending" ||
//                     jobApplicant!.status == "Viewed") {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () async {
//                           await context
//                               .read<MyJobsCubit>()
//                               .acceptJobApplication(jobApplicant!.job.id!,
//                                   jobApplicant!.applicant.id);
//                           context.read<MyJobsCubit>().getJobApplicantById(
//                               jobApplicant!.job.id!,
//                               jobApplicant!.applicant.id);
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green),
//                         child: Text("Accept"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           await context
//                               .read<MyJobsCubit>()
//                               .rejectJobApplication(jobApplicant!.job.id!,
//                                   jobApplicant!.applicant.id);
//                           context.read<MyJobsCubit>().getJobApplicantById(
//                               jobApplicant!.job.id!,
//                               jobApplicant!.applicant.id);
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red),
//                         child: Text("Reject"),
//                       ),
//                     ],
//                   );
//                 } else if (jobApplicant!.status == "Rejected") {
//                   return SizedBox(
//                     width: double.infinity,
//                     child: Container(
//                       padding: EdgeInsets.all(8.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.red, width: 2),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Applicant has been Rejected",
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return SizedBox(
//                     width: double.infinity,
//                     child: Container(
//                       padding: EdgeInsets.all(8.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.green, width: 2),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Applicant has been Accepted",
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16.sp,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//               },
//             )
//             // BlocBuilder<MyJobsCubit, MyJobsState>(builder: (context, state) {
//             //   if (state is MyJobApplicantLoaded) {
//             //     jobApplication = state.jobApplicant;
//             //   } else if (state is MyJobApplicantLoading) {
//             //     return CircularProgressIndicator();
//             //   }
//             //   if (jobApplication.status == "Pending" ||
//             //       jobApplication.status == "Viewed") {
//             //     return Row(
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       children: [
//             //         ElevatedButton(
//             //           onPressed: () async {
//             //             await context.read<MyJobsCubit>().acceptJobApplication(
//             //                 jobApplication.job.id!,
//             //                 jobApplication.applicant.id);
//             //             await context.read<MyJobsCubit>().getJobApplicantById(
//             //                 jobApplication.job.id!,
//             //                 jobApplication.applicant.id);
//             //           },
//             //           style: ElevatedButton.styleFrom(
//             //               backgroundColor: Colors.green),
//             //           child: Text("Accept"),
//             //         ),
//             //         ElevatedButton(
//             //           onPressed: () async {
//             //             await context.read<MyJobsCubit>().rejectJobApplication(
//             //                 jobApplication.job.id!,
//             //                 jobApplication.applicant.id);
//             //             await context.read<MyJobsCubit>().getJobApplicantById(
//             //                 jobApplication.job.id!,
//             //                 jobApplication.applicant.id);
//             //           },
//             //           style:
//             //               ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             //           child: Text("Reject"),
//             //         ),
//             //       ],
//             //     );
//             //   } else if (jobApplication.status == "Rejected") {
//             //     return SizedBox(
//             //       width: double.infinity,
//             //       child: Container(
//             //         padding: EdgeInsets.all(8.w),
//             //         decoration: BoxDecoration(
//             //           color: Colors.white,
//             //           border: Border.all(color: Colors.red, width: 2),
//             //           borderRadius: BorderRadius.circular(12.r),
//             //         ),
//             //         child: Center(
//             //           child: Text(
//             //             "Applicant has been Rejected",
//             //             style: TextStyle(
//             //               color: Colors.red,
//             //               fontWeight: FontWeight.bold,
//             //               fontSize: 16.sp,
//             //             ),
//             //           ),
//             //         ),
//             //       ),
//             //     );
//             //   } else {
//             //     // When applicant is accepted
//             //     return SizedBox(
//             //       width: double.infinity,
//             //       child: Container(
//             //         padding: EdgeInsets.all(8.w),
//             //         decoration: BoxDecoration(
//             //           color: Colors.white,
//             //           border: Border.all(color: Colors.green, width: 2),
//             //           borderRadius: BorderRadius.circular(12.r),
//             //         ),
//             //         child: Center(
//             //           child: Text(
//             //             "Applicant has been Accepted",
//             //             style: TextStyle(
//             //               color: Colors.green,
//             //               fontWeight: FontWeight.bold,
//             //               fontSize: 16.sp,
//             //             ),
//             //           ),
//             //         ),
//             //       ),
//             //     );
//             //   }
//             // }),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _openResume(
//       BuildContext context, String resumeUrl, String resumeName) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final localPath = '${directory.path}/$resumeName';
//     final file = File(localPath);

//     if (await file.exists()) {
//       await OpenFile.open(localPath);
//     } else if (await canLaunchUrl(Uri.parse(resumeUrl))) {
//       await launchUrl(Uri.parse(resumeUrl));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not open resume.")),
//       );
//     }
//   }

//   Widget buildResumeCard(BuildContext context, Resume resume) {
//     return GestureDetector(
//       onTap: () => _openResume(context, resume.url, resume.name),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.red.shade400),
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         padding: EdgeInsets.all(8.w),
//         child: Row(
//           children: [
//             // Extension badge
//             Container(
//               width: 50.w,
//               height: 50.w,
//               decoration: BoxDecoration(
//                 color: Colors.red.shade400,
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 resume.extension.replaceAll('.', '').toUpperCase(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(width: 8.w),

//             // Name, size, date
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     resume.name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14.sp,
//                       color: Colors.black,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     "${(resume.size / 1024.0).toStringAsFixed(1)} kB - Last updated on ${DateFormat('M/d/yyyy').format(resume.date)}",
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 12.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class JobApplicantList extends StatelessWidget {
  final List<JobApplication> jobApplications;

  const JobApplicantList({
    Key? key,
    required this.jobApplications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: ListView.builder(
        itemCount: jobApplications.length,
        itemBuilder: (context, index) {
          final jobApp = jobApplications[index];
          return BlocProvider(
              create: (context) => getIt<MyJobsCubit>(),
              child: JobApplicantCard(
                jobApplication: jobApp,
              ));
        },
      ),
    );
  }
}
