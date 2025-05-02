import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserCerificates extends StatefulWidget {
  const UserCerificates({super.key, required this.profile, this.isuser = true});
  final UserProfile profile;
  final bool isuser;

  @override
  State<UserCerificates> createState() => _UserCerificatesState();
}

class _UserCerificatesState extends State<UserCerificates> {
  bool _expanded = false;
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

    return "$issuedText • Present";
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
    final certifications = widget.profile.certifications;
    final displayList =
        _expanded ? certifications : certifications.take(1).toList();

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
              widget.isuser
                  ? IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routes.addCertificationScreen);
                      },
                      icon: Icon(Icons.add),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final cert = displayList[index];
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
                                  cert.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (widget.isuser) ...[
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.addCertificationScreen,
                                      arguments: cert,
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: ColorsManager.darkBurgundy,
                                    size: 20.r,
                                  ),
                                  onPressed: () {
                                    _showDeleteDialog(cert);
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
                            style: TextStyle(fontSize: 14.sp),
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
          if (certifications.length > 1)
            TextButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Text(_expanded
                  ? 'Show less Certificates'
                  : 'Show more Certificates'),
            ),
        ],
      ),
    );
  }

  void _showDeleteDialog(cert) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Certificate'),
          content: Text('Are you sure you want to delete "${cert.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context
                    .read<ProfileCubit>()
                    .deleteCertificate(cert.certificationId);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
