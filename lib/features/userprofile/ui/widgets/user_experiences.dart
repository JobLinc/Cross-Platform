import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserExperiences extends StatelessWidget {
  const UserExperiences({super.key, required this.profile, this.isuser = true});
  final UserProfile profile;
  final bool isuser;

  String _formatExperienceDates(dynamic startDate, dynamic endDate) {
    String issuedText = "";

    if (startDate is DateTime) {
      issuedText = "${_getMonthName(startDate.month)} ${startDate.year}";
    } else if (startDate is String) {
      issuedText = "$startDate";
    }

    if (endDate != null) {
      String expiredText = "";
      if (endDate is DateTime) {
        expiredText = "${_getMonthName(endDate.month)} ${endDate.year}";
      } else if (endDate is String) {
        final parsed = DateTime.tryParse(endDate);
        if (parsed != null) {
          expiredText = "${_getMonthName(parsed.month)} ${parsed.year}";
        } else {
          expiredText = endDate;
        }
      }

      return "$issuedText - $expiredText";
    }

    return issuedText;
  }

// Helper method to get month name
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Experiences',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              isuser
                  ? IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routes.addExperienceScreen);
                      },
                      icon: Icon(Icons.add))
                  : SizedBox.shrink(),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: profile.experiences.length,
            itemBuilder: (context, index) {
              final experience = profile.experiences[index];
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (experience.company.logo != null &&
                                  experience.company.logo!.isNotEmpty)
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 8.w, top: 2.h),
                                  child: Image.network(
                                    experience.company.logo!,
                                    width: 40.w,
                                    height: 40.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        SizedBox.shrink(),
                                  ),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                experience.position,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                "${experience.company.name} • ${experience.mode}",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isuser) ...[
                                          IconButton(
                                              onPressed: () async {
                                                Navigator.pushNamed(
                                                  context,
                                                  Routes.addExperienceScreen,
                                                  arguments: experience,
                                                );
                                              },
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: ColorsManager.darkBurgundy,
                                              size: 20.r,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    dialogContext) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Delete Experience'),
                                                    content: Text(
                                                        'Are you sure you want to delete "${experience.position}"?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(
                                                                  dialogContext)
                                                              .pop();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          print(experience.id);
                                                          Navigator.of(
                                                                  dialogContext)
                                                              .pop();
                                                          context
                                                              .read<
                                                                  ProfileCubit>()
                                                              .deleteExperience(
                                                                  experience
                                                                      .id);
                                                        },
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
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
                                      _formatExperienceDates(
                                          experience.startDate,
                                          experience.endDate),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (experience.type != '')
                                      Column(
                                        children: [
                                          SizedBox(height: 4.h),
                                          Text(
                                            experience.type!,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      experience.description,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
