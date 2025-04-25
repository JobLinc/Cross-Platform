import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_applicants_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_details_screen.dart';

// class JobCard extends StatelessWidget {
//   final Job job;
//   final Function? press;
//   const JobCard(
//       {super.key, required this.job, this.press, required int itemIndex});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       key: Key("jobs_openJob_card${job.id}"),
//       onTap: () {
//         if (press != null) {
//           press!();
//         }
//       },
//       // child: ScreenUtilInit(
//       //   designSize:
//       //       Size(375, 812), // Set based on your design (width, height)
//       //   minTextAdapt: true,
//       //   splitScreenMode: true,
//       child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 2,
//               child: Padding(
//                 padding: EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(children: [
//                       Expanded(
//                         child: Text(job.title!,
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold)),
//                       ),
//                       Icon(Icons.verified, color: Colors.blue, size: 18),
//                     ]),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       job.company!.name!,
//                       style: TextStyle(fontSize: 14, color: Colors.black87),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       "${job.location!.country!}, ${job.location!.city!}",
//                       style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                     ),
//                     SizedBox(height: 6),
//                     Row(
//                       children: [
//                         Icon(Icons.school, size: 16, color: Colors.grey[700]),
//                         SizedBox(
//                           width: 4,
//                         ),
//                         Text(
//                           "${job.company!.size}",
//                           style:
//                               TextStyle(fontSize: 14, color: Colors.grey[700]),
//                         )
//                       ],
//                     ),
//                     SizedBox(height: 6),
//                     Text("Promoted",
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]))
//                   ],
//                 ),
//               ))),
//     );
//   }
// }

// class JobCard extends StatelessWidget {
//   final Job job;
//   final VoidCallback? press;
//   const JobCard({
//     super.key,
//     required this.job,
//     this.press,
//     required int itemIndex, // you don’t actually use this in the build
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Format salary: e.g. "USD 9,000–14,000"
//     final salaryText = "${job.salaryRange.currency} "
//         "${job.salaryRange.min.toStringAsFixed(0)}–"
//         "${job.salaryRange.max.toStringAsFixed(0)}";

//     return GestureDetector(
//       key: Key("jobs_openJob_card${job.id}"),
//       onTap: press,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//         child: Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           elevation: 2.h,
//           child: Padding(
//             padding: EdgeInsets.all(12.r),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20.r,
//                   backgroundImage: NetworkImage(job.company.logo),
//                   backgroundColor: Colors.grey.shade200,
//                 ),
//                 SizedBox(width: 12.w),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Top row: avatar + title + exp level + salary + verified icon
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // 1) Company logo
//                         CircleAvatar(
//                           radius: 20.r,
//                           backgroundImage: NetworkImage(job.company.logo),
//                           backgroundColor: Colors.grey.shade200,
//                         ),
//                         SizedBox(width: 12.w),
//                         // Expand to take the rest
//                         Expanded(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               // Job title
//                               Expanded(
//                                 child: Text(
//                                   job.title!,
//                                   style: TextStyle(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               SizedBox(width: 8.w),
//                               // Experience level
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 6.w, vertical: 2.h),
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue.shade50,
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: Text(
//                                   job.experienceLevel!,
//                                   style: TextStyle(
//                                       fontSize: 12.sp, color: Colors.blue),
//                                 ),
//                               ),

//                               SizedBox(width: 8.w),

//                               // Salary
//                               Text(
//                                 salaryText,
//                                 style: TextStyle(
//                                     fontSize: 12.sp, color: Colors.green),
//                               ),

//                               SizedBox(width: 4.w),

//                               // Verified icon (optional)
//                               Icon(Icons.verified,
//                                   color: Colors.blue, size: 18.r),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 8.h),
//                     // Company name
//                     Text(
//                       job.company.name!,
//                       style: TextStyle(fontSize: 14.sp, color: Colors.black87),
//                     ),
//                     SizedBox(height: 4.h),
//                     // Location
//                     Text(
//                       "${job.location.country!}, ${job.location.city!}",
//                       style:
//                           TextStyle(fontSize: 14, color: Colors.grey.shade700),
//                     ),
//                     SizedBox(height: 6.h),
//                     // Company size (unchanged)
//                     Row(
//                       children: [
//                         Icon(Icons.school,
//                             size: 16, color: Colors.grey.shade700),
//                         SizedBox(width: 4.w),
//                         Text(
//                           job.company.size!,
//                           style: TextStyle(
//                               fontSize: 14.sp, color: Colors.grey.shade700),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 6.h),
//                     // Promoted tag (unchanged)
//                     Text("Promoted",
//                         style: TextStyle(
//                             fontSize: 12.sp, color: Colors.grey.shade600)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class JobCard extends StatelessWidget {
//   final Job job;
//   final VoidCallback? press;
//   //final bool savedPage;
//   const JobCard({
//     super.key,
//     required this.job,
//     this.press,
//     //this.savedPage=false,
//     required int itemIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Format salary: e.g. "USD 9,000–14,000"
//     final salaryText = "${job.salaryRange.currency} "
//         "${job.salaryRange.min.toStringAsFixed(0)}–"
//         "${job.salaryRange.max.toStringAsFixed(0)}";

//     return GestureDetector(
//       key: Key("jobs_openJob_card${job.id}"),
//       onTap: press,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.r),
//           ),
//           elevation: 2.h,
//           child: Padding(
//             padding: EdgeInsets.all(12.r),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Company logo
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, Routes.companyPageHome,
//                         arguments: job.company.id);
//                   },
//                   child: CircleAvatar(
//                     radius: 40.r,
//                     backgroundImage: NetworkImage(job.company.logo),
//                     backgroundColor: Colors.grey.shade200,
//                   ),
//                 ),

//                 SizedBox(width: 12.w),

//                 // This Expanded is crucial
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Top row: title, exp level, salary, verified
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Job title
//                           Expanded(
//                             child: Text(
//                               job.title!,
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),

//                           SizedBox(width: 8.w),

//                           // Verified icon
//                           Icon(
//                             Icons.verified,
//                             color: Colors.blue,
//                             size: 18.r,
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 8.h),

//                       // Company name
//                       Text(
//                         job.company.name!,
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Colors.black87,
//                         ),
//                       ),

//                       SizedBox(height: 4.h),

//                       // Location
//                       Text(
//                         "${job.location.country!}, ${job.location.city!}",
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),

//                       SizedBox(height: 6.h),

//                       // Company size
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.school,
//                             size: 16.r,
//                             color: Colors.grey.shade700,
//                           ),
//                           SizedBox(width: 4.w),
//                           Text(
//                             job.company.size!,
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 6.h),

//                       // Experience Level & Salary Row
//                       Row(
//                         children: [
//                           // Experience Level
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 6.w, vertical: 2.h),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.shade50,
//                               borderRadius: BorderRadius.circular(4.r),
//                             ),
//                             child: Text(
//                               job.experienceLevel!,
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 8.w),

//                           // Salary
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 6.w, vertical: 2.h),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade50,
//                               borderRadius: BorderRadius.circular(4.r),
//                             ),
//                             child: Text(
//                               "${job.salaryRange.min.toStringAsFixed(0)}–${job.salaryRange.max.toStringAsFixed(0)} ${job.salaryRange.currency}",
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class JobCard extends StatelessWidget {
  final Job job;
  final bool savedPage;
  //final VoidCallback? press;
   JobCard({
    super.key,
    required this.job,
    this.savedPage=false,
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

      //       final ownerId = hasCompany
      // ? widget.job.company!.id
      // : widget.job.employer!.id;

      //final bool isCreated= !hasCompany && userId !=null && ownerId==userId!;
    onAvatarTap() {
      if (hasCompany) {
        Navigator.pushNamed(context, Routes.companyPageHome,
            arguments: job.company!.id);
      } else {
        // e.g. navigate to an employer-profile screen
        Navigator.pushNamed(context, Routes.otherProfileScreen,
            arguments: job.employer);
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
      final ownerId   = hasCompany ? job.company!.id : job.employer!.id;
      final isCreated = !hasCompany && ownerId == userId;
    return GestureDetector(
      key: Key("jobs_openJob_card${job.id}"),
      onTap: (){
                    showJobDetails(context, job, savedPage,isCreated: isCreated);
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
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundImage: NetworkImage(ownerAvatar),
                    backgroundColor: Colors.grey.shade200,
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
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 18.r,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // owner name
                      Text(
                        ownerName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // owner subtitle (size or username)
                      Text(
                        ownerSubtitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // location
                      Text(
                        "${job.location.country}, ${job.location.city}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // experience & salary
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              job.experienceLevel,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 120.w),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(4.r),
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
    );
  });
  }
}

class JobList extends StatelessWidget {
  final List<Job> jobs;
  final bool isCreated;
  final bool savedPage;

  const JobList(
      {super.key,
      required this.jobs,
      this.isCreated = false,
      this.savedPage = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: ListView.builder(
          key: ValueKey(jobs.length),
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemCount: jobs.length,
          itemBuilder: (context, index) => JobCard(
                itemIndex: index,
                job: jobs[index],
                //savedPage: savedPage,
                // press: () {
                //   if (isCreated) {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (_) => BlocProvider(
                //                   create: (context) => getIt<MyJobsCubit>(),
                //                   child: JobApplicantsScreen(
                //                     job: jobs[index],
                //                   ),
                //                 )));
                //   } else {
                //     showJobDetails(context, jobs[index], savedPage);
                //   }
                //   //print("Tapped on: ${sortedChats[index].userName}");
                // },
                savedPage: savedPage,
              )),
    );
  }
}

void showJobDetails(BuildContext context, Job jobDetails, bool savedPage, {bool isCreated=false}) {
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
 // Experience level pill
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 6.w,
                          //     vertical: 2.h,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: Colors.blue.shade50,
                          //     borderRadius: BorderRadius.circular(4.r),
                          //   ),
                          //   child: Text(
                          //     job.experienceLevel!,
                          //     style: TextStyle(
                          //       fontSize: 12.sp,
                          //       color: Colors.blue,
                          //     ),
                          //   ),
                          // ),

                          // SizedBox(width: 8.w),

                          // // Salary
                          // Text(
                          //   salaryText,
                          //   style: TextStyle(
                          //     fontSize: 12.sp,
                          //     color: Colors.green,
                          //   ),
                          // ),

                          // SizedBox(width: 4.w),
 // Promoted tag
                      // Text(
                      //   "Promoted",
                      //   style: TextStyle(
                      //     fontSize: 12.sp,
                      //     color: Colors.grey.shade600,
                      //   ),
                      // ),