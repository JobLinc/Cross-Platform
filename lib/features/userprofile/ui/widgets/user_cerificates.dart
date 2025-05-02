import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserCerificates extends StatelessWidget {
  const UserCerificates({super.key, required this.profile, this.isuser = true});
  final UserProfile profile;
  final bool isuser;

  String _formatCertificateDates(dynamic startYear, dynamic endYear) {
    String issuedText = "";

    if (startYear is DateTime) {
      issuedText = "Issued ${_getMonthName(startYear.month)} ${startYear.year}";
    } else if (startYear is String) {
      issuedText = "Issued $startYear";
    }

    if (endYear != null) {
      String expiredText = "";
      if (endYear is DateTime) {
        expiredText = "Expired ${_getMonthName(endYear.month)} ${endYear.year}";
      } else if (endYear is String) {
        expiredText = "Expired $endYear";
      }

      return "$issuedText • $expiredText";
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
                'Licenses & Certifications',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              isuser
                  ? IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routes.addCertificationScreen);
                      },
                      icon: Icon(Icons.add))
                  : SizedBox.shrink(),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: profile.certifications.length,
            itemBuilder: (context, index) {
              final cert = profile.certifications[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5.h), // Reduced from 8.h to 4.h
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Put name and delete icon in the same row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  cert.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isuser) ...[
                                IconButton(
                                    onPressed: () async {
                                      Navigator.pushNamed(context,
                                          Routes.addCertificationScreen,
                                          arguments: cert);
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
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: Text('Delete Certificate'),
                                          content: Text(
                                              'Are you sure you want to delete "${cert.name}"?'),
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
                                                    .deleteCertificate(
                                                        cert.certificationId);
                                                // Close dialog and delete certificate
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
                            cert.organization,
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _formatCertificateDates(
                                cert.startYear, cert.endYear),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[500],
                            thickness: 1,
                            height: 15
                                .h, // Explicitly set height to control spacing
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
