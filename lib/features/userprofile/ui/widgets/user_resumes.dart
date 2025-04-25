import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserResumes extends StatelessWidget {
  const UserResumes({super.key, required this.profile, this.isuser = true});
  final UserProfile profile;
  final bool isuser;

  String _formatFileSize(int sizeInBytes) {
    if (sizeInBytes >= 1024 * 1024) {
      return "${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else if (sizeInBytes >= 1024) {
      return "${(sizeInBytes / 1024).toStringAsFixed(2)} KB";
    }
    return "$sizeInBytes B";
  }

  String _formatDate(DateTime date) {
    return "${_getMonthName(date.month)} ${date.day}, ${date.year}";
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
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Uploaded Resumes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: profile.resumes.length,
            itemBuilder: (context, index) {
              final resume = profile.resumes[index];
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
                                  resume.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isuser) ...[
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: ColorsManager.darkBurgundy,
                                    size: 20.r,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: Text('Delete Resume'),
                                          content: Text(
                                              'Are you sure you want to delete "${resume.name}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(dialogContext)
                                                    .pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(dialogContext)
                                                    .pop();
                                                context
                                                    .read<ProfileCubit>()
                                                    .deleteresume(resume.id);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  splashRadius: 20.r,
                                ),
                              ]
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _formatFileSize(resume.size),
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Uploaded ${_formatDate(resume.createdAt)}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[500],
                            thickness: 1,
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
