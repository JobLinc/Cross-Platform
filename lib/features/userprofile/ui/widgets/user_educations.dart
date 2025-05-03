import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserEducations extends StatefulWidget {
  const UserEducations({super.key, required this.profile, this.isUser = true});
  final UserProfile profile;
  final bool isUser;

  @override
  State<UserEducations> createState() => _UserEducationsState();
}

class _UserEducationsState extends State<UserEducations> {
  bool isExpanded = false;
  String _formatEducationDates(dynamic startYear, dynamic endYear) {
    String startText = '';
    String endText = '';

    if (startYear is DateTime) {
      startText = '${_getMonthName(startYear.month)} ${startYear.year}';
    } else if (startYear is String) {
      startText = startYear;
    }

    if (endYear != null) {
      if (endYear is DateTime) {
        endText = '${_getMonthName(endYear.month)} ${endYear.year}';
      } else if (endYear is String) {
        endText = endYear;
      }
    } else {
      endText = 'Present';
    }

    return '$startText • $endText';
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final educationList = widget.profile.education ?? [];
    final visibleItems =
        isExpanded ? educationList : educationList.take(1).toList();

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Education', style: Theme.of(context).textTheme.titleLarge),
              if (widget.isUser)
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.addEducationScreen);
                  },
                  icon: Icon(Icons.add),
                ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: visibleItems.length,
            itemBuilder: (context, index) {
              final education = visibleItems[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  education.school,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (widget.isUser) ...[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.addEducationScreen,
                                      arguments: education,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: ColorsManager.darkBurgundy,
                                      size: 20.r),
                                  onPressed: () {
                                    _showDeleteDialog(context, education);
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  splashRadius: 20.r,
                                ),
                              ]
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text("Field of Study: ${education.fieldOfStudy}",
                              style: TextStyle(fontSize: 14.sp)),
                          SizedBox(height: 4.h),
                          Text("Degree: ${education.degree}",
                              style: TextStyle(fontSize: 14.sp)),
                          if (education.startDate != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              _formatEducationDates(
                                  education.startDate, education.endDate),
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey[600]),
                            ),
                          ],
                          if (education.cgpa != null)
                            Text("CGPA: ${education.cgpa}",
                                style: TextStyle(fontSize: 14.sp)),
                          if (education.description != null)
                            Text(
                              "Description: ${education.description}",
                              style: TextStyle(fontSize: 14.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Divider(
                              color: Colors.grey[500],
                              thickness: 1,
                              height: 15.h),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (educationList.length > 1)
            TextButton(
              onPressed: () => setState(() => isExpanded = !isExpanded),
              child: Text(
                  isExpanded ? 'Show Less Educations' : 'Show More Educations'),
            ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, education) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete Education'),
        content: Text('Are you sure you want to delete "${education.school}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<ProfileCubit>()
                  .deleteEducation(education.educationId);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
