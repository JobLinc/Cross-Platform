// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:joblinc/core/di/dependency_injection.dart';
// import 'package:joblinc/features/jobs/data/models/job_model.dart';
// import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
// import 'package:joblinc/features/jobs/ui/screens/job_application_screen.dart';

// class JobDetailScreen extends StatefulWidget {
//   final Job jobDetails;
//   final ScrollController scrollController;

//   const JobDetailScreen({
//     super.key,
//     required this.scrollController,
//     required this.jobDetails,
//   });

//   @override
//   State<JobDetailScreen> createState() => _JobDetailScreenState();
// }

// class _JobDetailScreenState extends State<JobDetailScreen> {
//   //late List<Job> _savedJobs;
//   late List<Job> appliedJobs;
//   late List<Job> savedJobs;
//   bool? isApplied =false;
//   bool? isSaved =false;
//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     //context.read<JobListCubit>().getSavedJobs();
//     context.read<JobListCubit>().getJobDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return BlocListener<JobListCubit, JobListState>(
//       listener: (context, state) {
//         if (state is JobDetailsLoading) {
//           setState(() {
//             loading = true;
//           });
//         } else if (state is JobDetailsLoaded) {
//           setState(() {
//             appliedJobs = state.appliedJobs;
//             savedJobs = state.savedJobs;
//             isApplied =
//                 appliedJobs.any((job) => job.id == widget.jobDetails.id);
//             isSaved = savedJobs.any((job) => job.id == widget.jobDetails.id);
//             loading = false;
//           });
//         }
//       },
//       child: Material(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           padding: EdgeInsets.all(16.w),
//           child: SingleChildScrollView(
//             controller: widget.scrollController,
//             physics: ClampingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40.w,
//                     height: 5.h,
//                     margin: EdgeInsets.only(bottom: 16.h),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "${widget.jobDetails.company!.name}",
//                   style:
//                       TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 8.h,
//                 ),
//                 Text(
//                   "${widget.jobDetails.industry} - ${widget.jobDetails.title}",
//                   style:
//                       TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 8.h,
//                 ),
//                 Text(
//                   " ${widget.jobDetails.location!.city}, ${widget.jobDetails.location!.city}, ${widget.jobDetails.location!.country}",
//                   style: TextStyle(fontSize: 14.sp),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   "Reposted ${DateFormat.MMMd().format(widget.jobDetails.createdAt!)} - ${DateFormat.jm().format(widget.jobDetails.createdAt!)}",
//                   style: TextStyle(fontSize: 14.sp),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   "${widget.jobDetails.company!.size}",
//                   style: TextStyle(fontSize: 14.sp),
//                 ),
//                 SizedBox(height: 16.h),
//                 Row(
//                   children: [
//                     Chip(label: Text("${widget.jobDetails.workplace}")),
//                     SizedBox(width: 8.h,),
//                     Chip(label: Text("${widget.jobDetails.type}")),
//                     SizedBox(width: 8.h,),
//                     Chip(label: Text("${widget.jobDetails.experienceLevel}")),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 if (loading)
//                   SizedBox(
//                     width: screenWidth * 0.9,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red[400],
//                         foregroundColor: Colors.white,
//                       ),
//                       child: Text("Loading"),
//                     ),
//                   )
//                 else
//                   BlocBuilder<JobListCubit, JobListState>(
//                     builder: (context, state) {
//                       if (state is JobDetailsLoading) {
//                         return SizedBox(
//                           width: screenWidth * 0.9,
//                           child: ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   Colors.red[400], // Dim color when applied
//                               foregroundColor: Colors.white,
//                             ),
//                             child: Text("Loading"),
//                           ),
//                         );
//                       } else if (state is JobAppliedLoaded) {
//                           isApplied = state.appliedJobs
//                               .any((job) => job.id == widget.jobDetails.id);
//                         return SizedBox(
//                           width: screenWidth * 0.9,
//                           child: ElevatedButton(
//                             onPressed: isApplied!
//                                 ? null // Disable button if applied
//                                 : () async {
//                                     await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => BlocProvider(
//                                           create: (context) =>
//                                               getIt<JobListCubit>(),
//                                           child: JobApplicationScreen(
//                                               job: widget.jobDetails),
//                                         ),
//                                       ),
//                                     );
//                                     context
//                                         .read<JobListCubit>()
//                                         .getAppliedJobs();
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: isApplied!
//                                   ? Colors.grey[400]
//                                   : Colors.red[400], // Dim color when applied
//                               foregroundColor: Colors.white,
//                             ),
//                             child: Text(isApplied! ? "Applied" : "Apply"),
//                           ),
//                         );
//                       } else {
//                           return SizedBox(
//                             width: screenWidth * 0.9,
//                             child: ElevatedButton(
//                               onPressed: isApplied!
//                                   ? null // Disable button if applied
//                                   : () async {
//                                       await Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => BlocProvider(
//                                             create: (context) =>
//                                                 getIt<JobListCubit>(),
//                                             child: JobApplicationScreen(
//                                                 job: widget.jobDetails),
//                                           ),
//                                         ),
//                                       );
//                                       await context
//                                           .read<JobListCubit>()
//                                           .getAppliedJobs();
//                                     },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: isApplied!
//                                     ? Colors.grey[400]
//                                     : Colors.red[400], // Dim color when applied
//                                 foregroundColor: Colors.white,
//                               ),
//                               child: Text(isApplied! ? "Applied" : "Apply"),
//                             ),
//                           );
//                       }
//                     },
//                   ),

//                 BlocBuilder<JobListCubit, JobListState>(
//                   builder: (context, state) {
//                     if (state is JobDetailsLoading) {
//                       return SizedBox(
//                         width: screenWidth * 0.9,
//                         child: OutlinedButton.icon(
//                           onPressed: () {},
//                           label: Text(
//                             "Loading",
//                             style: TextStyle(
//                                 color: Colors.red[400], fontSize: 16.sp),
//                           ),
//                           //icon: Icon(Icons.circle, color: Colors.red[400]),
//                           style: OutlinedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             side: BorderSide(color: Colors.red[400]!),
//                           ),
//                         ),
//                       );
//                     } else if (state is JobSavedLoaded) {
//                         isSaved = state.savedJobs
//                             .any((job) => job.id == widget.jobDetails.id);
//                       return SizedBox(
//                         width: screenWidth * 0.9,
//                         child: OutlinedButton.icon(
//                           onPressed: () async{
//                               if (isSaved!) {
//                                 await context
//                                     .read<JobListCubit>()
//                                     .unsaveJob(widget.jobDetails.id!);
//                               } else {
//                                 await context
//                                     .read<JobListCubit>()
//                                     .saveJob(widget.jobDetails.id!);
//                               }
//                               await context.read<JobListCubit>().getSavedJobs();
//                           },
//                           icon: isSaved!
//                               ? Icon(Icons.check, color: Colors.red[400])
//                               : SizedBox.shrink(),
//                           label: Text(
//                             isSaved! ? "Saved" : "Save",
//                             style: TextStyle(
//                                 color: Colors.red[400], fontSize: 16.sp),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             side: BorderSide(color: Colors.red[400]!),
//                           ),
//                         ),
//                       );
//                     } else {
//                         return SizedBox(
//                           width: screenWidth * 0.9,
//                           child: OutlinedButton.icon(
//                             onPressed: () {
//                               setState(() {
//                                 if (isSaved!) {
//                                   context
//                                       .read<JobListCubit>()
//                                       .unsaveJob(widget.jobDetails.id!);
//                                 } else {
//                                   context
//                                       .read<JobListCubit>()
//                                       .saveJob(widget.jobDetails.id!);
//                                 }
//                                 context.read<JobListCubit>().getSavedJobs();
//                               });
//                             },
//                             icon: isSaved!
//                                 ? Icon(Icons.check, color: Colors.red[400])
//                                 : SizedBox.shrink(),
//                             label: Text(
//                               isSaved! ? "Saved" : "Save",
//                               style: TextStyle(
//                                   color: Colors.red[400], fontSize: 16.sp),
//                             ),
//                             style: OutlinedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               side: BorderSide(color: Colors.red[400]!),
//                             ),
//                           ),
//                         );
//                     }
//                   },
//                 ),
//                 SizedBox(height: 16.h),
//                 Text(
//                   "${widget.jobDetails.description}",
//                   style:
//                       TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
//                 ),
//                 //Text("Get AI-powered advice on this job and more exclusive features with Premium."),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:joblinc/core/di/dependency_injection.dart';
// import 'package:joblinc/features/jobs/data/models/job_model.dart';
// import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
// import 'package:joblinc/features/jobs/ui/screens/job_application_screen.dart';

// class JobDetailScreen extends StatefulWidget {
//   final Job jobDetails;
//   final ScrollController scrollController;

//   const JobDetailScreen({
//     super.key,
//     required this.scrollController,
//     required this.jobDetails,
//   });

//   @override
//   State<JobDetailScreen> createState() => _JobDetailScreenState();
// }

// class _JobDetailScreenState extends State<JobDetailScreen> {
//   late List<Job> appliedJobs;
//   late List<Job> savedJobs;
//   bool isApplied = false;
//   bool isSaved = false;
//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<JobListCubit>().getJobDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final job = widget.jobDetails;
//     final company = job.company!;
//     final location = job.location!;
//     final salary = job.salaryRange;
//     final skills = job.keywords ?? <String>[];

//     return BlocListener<JobListCubit, JobListState>(
//       listener: (context, state) {
//         if (state is JobDetailsLoading) {
//           setState(() => loading = true);
//         } else if (state is JobDetailsLoaded) {
//           appliedJobs = state.appliedJobs;
//           savedJobs = state.savedJobs;
//           isApplied = appliedJobs.any((j) => j.id == job.id);
//           isSaved   = savedJobs.any((j) => j.id == job.id);
//           setState(() => loading = false);
//         }
//       },
//       child: Material(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//         child: Container(
//           color: Colors.white,
//           padding: EdgeInsets.all(16.w),
//           child: SingleChildScrollView(
//             controller: widget.scrollController,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // drag handle
//                 Center(
//                   child: Container(
//                     width: 40.w, height: 5.h,
//                     margin: EdgeInsets.only(bottom: 16.h),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                   ),
//                 ),

//                 // Company logo + name + title
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 24.r,
//                       backgroundImage: NetworkImage(
//                         company.logo ?? 'https://via.placeholder.com/150'
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             company.name!,
//                             style: TextStyle(
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             job.title!,
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),

//                 // Full location
//                 Text(
//                   '${location.address}, ${location.city}, ${location.country}',
//                   style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
//                 ),
//                 SizedBox(height: 8.h),

//                 // Posted date/time
//                 Text(
//                   'Posted ${DateFormat.yMMMd().add_jm().format(job.createdAt!)}',
//                   style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
//                 ),
//                 SizedBox(height: 8.h),

//                 // Company size
//                 Text(
//                   'Company size: ${company.size}',
//                   style: TextStyle(fontSize: 14.sp),
//                 ),
//                 SizedBox(height: 16.h),

//                 // Attributes chips
//                 Wrap(
//                   spacing: 8.w,
//                   runSpacing: 8.h,
//                   children: [
//                     Chip(label: Text(job.workplace!)),
//                     Chip(label: Text(job.type!)),
//                     Chip(label: Text(job.experienceLevel!)),
//                     if (salary != null)
//                       Chip(label: Text(
//                         '${salary.min?.toStringAsFixed(0)}–${salary.max?.toStringAsFixed(0)} ${salary.currency}'
//                       )),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),

//                 // Skills
//                 if (skills.isNotEmpty) ...[
//                   Text('Skills', style: TextStyle(
//                     fontSize: 16.sp, fontWeight: FontWeight.bold
//                   )),
//                   SizedBox(height: 8.h),
//                   Wrap(
//                     spacing: 8.w,
//                     runSpacing: 8.h,
//                     children: skills.map((s) => Chip(label: Text(s))).toList(),
//                   ),
//                   SizedBox(height: 16.h),
//                 ],

//                 // Apply / Save buttons
//                 _buildActionButtons(context),

//                 SizedBox(height: 24.h),

//                 // Description
//                 Text(
//                   'Job Description',
//                   style: TextStyle(
//                     fontSize: 16.sp, fontWeight: FontWeight.bold
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   job.description!,
//                   style: TextStyle(fontSize: 14.sp),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         // Apply
//         SizedBox(
//           width: screenWidth * 0.9,
//           child: loading
//             ? ElevatedButton(onPressed: null, child: Text('Loading…'))
//             : BlocBuilder<JobListCubit, JobListState>(
//                 builder: (ctx, state) {
//                   return ElevatedButton(
//                     onPressed: isApplied
//                       ? null
//                       : () async {
//                           await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => BlocProvider.value(
//                                 value: context.read<JobListCubit>(),
//                                 child: JobApplicationScreen(job: widget.jobDetails),
//                               ),
//                             ),
//                           );
//                           context.read<JobListCubit>().getAppliedJobs();
//                         },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                         isApplied ? Colors.grey : Colors.red,
//                     ),
//                     child: Text(isApplied ? 'Applied' : 'Apply'),
//                   );
//                 },
//               ),
//         ),
//         SizedBox(height: 12.h),
//         // Save
//         SizedBox(
//           width: screenWidth * 0.9,
//           child: BlocBuilder<JobListCubit, JobListState>(
//             builder: (ctx, state) {
//               return OutlinedButton.icon(
//                 onPressed: () async {
//                   if (isSaved) {
//                     await context.read<JobListCubit>().unsaveJob(widget.jobDetails.id!);
//                   } else {
//                     await context.read<JobListCubit>().saveJob(widget.jobDetails.id!);
//                   }
//                   await context.read<JobListCubit>().getSavedJobs();
//                 },
//                 icon: isSaved
//                   ? Icon(Icons.check, color: Colors.red)
//                   : SizedBox.shrink(),
//                 label: Text(isSaved ? 'Saved' : 'Save'),
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Colors.red),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_styles.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_application_screen.dart';

class JobDetailScreen extends StatefulWidget {
  final Job jobDetails;
  final ScrollController scrollController;
  final bool savedPage;

  const JobDetailScreen(
      {super.key,
      required this.scrollController,
      required this.jobDetails,
      this.savedPage = false});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late List<Job> appliedJobs;
  late List<Job> savedJobs;
  bool isApplied = false;
  bool isSaved = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    context.read<JobListCubit>().getJobDetails();
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.jobDetails;
    final company = job.company!;
    final location = job.location!;
    final salary = job.salaryRange;
    final skills = job.skills ?? <String>[];

    return BlocListener<JobListCubit, JobListState>(
      listener: (context, state) {
        if (state is JobDetailsLoading) {
          setState(() => loading = true);
        } else if (state is JobDetailsLoaded) {
          appliedJobs = state.appliedJobs;
          savedJobs = state.savedJobs;
          isApplied = appliedJobs.any((j) => j.id == job.id);
          isSaved = savedJobs.any((j) => j.id == job.id);
          setState(() => loading = false);
        }
      },
      child: Material(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        color: ColorsManager.getBackgroundColor(context),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // drag handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: ColorsManager.mutedSilver,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),

                // Company logo + name + title
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: ColorsManager.lightGray,
                      backgroundImage: NetworkImage(company.logo ?? ''),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       Row(
                              children: [
                                Text(
                                  company.name,
                                  style: TextStyles.font18Bold(context),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 25.w,
                                ),
                                Icon(
                                  Icons.person, // or any icon you prefer
                                  size: 18.r,
                                  color: ColorsManager.getPrimaryColor(context),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "${job.company.followers}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorsManager.getPrimaryColor(context),
                                  ),
                                )
                              ],
                            ),
                  
                          SizedBox(height: 4.h),
                          Text(
                            job.title,
                            style: TextStyles.font13Medium(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Full location
                Text(
                  '${location.address}, ${location.city}, ${location.country}',
                  style: TextStyles.font14Regular(context),
                ),
                SizedBox(height: 8.h),

                // Posted date/time
                Text(
                  'Posted ${DateFormat.yMMMd().add_jm().format(job.createdAt)}',
                  style: TextStyles.font13GrayRegular(context),
                ),
                SizedBox(height: 8.h),

                // Company size
                Text(
                  'Company size: ${company.size}',
                  style: TextStyles.font14Regular(context),
                ),
                SizedBox(height: 16.h),

                // Attributes chips
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    Chip(
                      backgroundColor: ColorsManager.softMutedSilver,
                      label: Text(job.workplace!,
                          style: TextStyles.font13Medium(context)),
                    ),
                    Chip(
                      backgroundColor: ColorsManager.softMutedSilver,
                      label: Text(job.type!,
                          style: TextStyles.font13Medium(context)),
                    ),
                    Chip(
                      backgroundColor: ColorsManager.softMutedSilver,
                      label: Text(job.experienceLevel!,
                          style: TextStyles.font13Medium(context)),
                    ),
                    if (salary != null)
                      Chip(
                        backgroundColor: ColorsManager.softMutedSilver,
                        label: Text(
                          '${salary.min.toStringAsFixed(0)}–${salary.max.toStringAsFixed(0)} ${salary.currency}',
                          style: TextStyles.font13Medium(context),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Apply / Save buttons
                _buildActionButtons(context),

                SizedBox(height: 24.h),

                // Description
                Text(
                  'Job Description',
                  style: TextStyles.font16WhiteSemiBold.copyWith(
                    color: ColorsManager.getTextPrimary(context),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  job.description!,
                  style: TextStyles.font14Regular(context),
                ),

                SizedBox(height: 24.h),

                // Skills
                if (skills.isNotEmpty) ...[
                  Text('Skills',
                      style: TextStyles.font16WhiteSemiBold.copyWith(
                        color: ColorsManager.getTextPrimary(context),
                      )),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: skills
                        .map((s) => Chip(
                              backgroundColor: ColorsManager.lightGray,
                              label: Text(s,
                                  style: TextStyles.font13Regular(context)),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 16.h),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final primary = ColorsManager.getPrimaryColor(context);
    return Column(
      children: [
        // Apply Button
        SizedBox(
          width: screenWidth * 0.9,
          child: loading
              ? ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: primary),
                  child: Text('Loading…',
                      style: TextStyles.font13SemiBold(context)),
                )
              : BlocBuilder<JobListCubit, JobListState>(
                  builder: (_, state) => ElevatedButton(
                    onPressed: isApplied
                        ? null
                        : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<JobListCubit>(),
                                  child: JobApplicationScreen(
                                      job: widget.jobDetails),
                                ),
                              ),
                            );
                            context.read<JobListCubit>().getAppliedJobs();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isApplied ? ColorsManager.lightGray : primary,
                    ),
                    child: Text(
                      isApplied ? 'Applied' : 'Apply',
                      style: TextStyles.font13SemiBold(context).copyWith(
                        color: isApplied
                            ? ColorsManager.getTextPrimary(context)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
        ),
        SizedBox(height: 2.h),
        // Save Button
        SizedBox(
          width: screenWidth * 0.9,
          child: BlocBuilder<JobListCubit, JobListState>(
            builder: (_, state) => OutlinedButton.icon(
              onPressed: () async {
                if (isSaved) {
                  await context
                      .read<JobListCubit>()
                      .unsaveJob(widget.jobDetails.id);
                } else {
                  await context
                      .read<JobListCubit>()
                      .saveJob(widget.jobDetails.id);
                }
                //await context.read<JobListCubit>().getSavedJobs();
                setState(() {
                  isSaved = !isSaved;
                });
                if (widget.savedPage) {
                  // await context
                  //     .read<JobListCubit>()
                  //     .unsaveJob(widget.jobDetails.id);
                  Navigator.pop(context, true);
                }
              },
              icon: isSaved
                  ? Icon(Icons.check, color: primary)
                  : SizedBox.shrink(),
              label: Text(
                isSaved ? 'Saved' : 'Save',
                style:
                    TextStyles.font13SemiBold(context).copyWith(color: primary),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
