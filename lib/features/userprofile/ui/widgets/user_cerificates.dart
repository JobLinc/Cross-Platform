import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

class UserCerificates extends StatelessWidget {
  const UserCerificates({super.key, required this.profile});
  final UserProfile profile;

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
                'Licenses & certifications',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: profile.certifications.length,
            itemBuilder: (context, index) {
              final cert = profile.certifications[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.card_membership,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
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
