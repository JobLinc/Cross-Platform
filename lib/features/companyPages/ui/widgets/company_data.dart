import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companyPages/ui/widgets/company_more.dart';
import 'package:joblinc/features/companyPages/ui/widgets/follow_button.dart';
import 'package:joblinc/features/companyPages/ui/widgets/visit_company_website.dart';
import '../widgets/square_avatar.dart';
import '../../data/company.dart';
import 'scrollable_bar.dart';

class CompanyData extends StatelessWidget {
  final Company company;

  CompanyData({required this.company, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stack containing only the Cover Image and Logo
        Container(
          height: 60.h,
          child: Stack(
            children: [
              Image.network(
                company.coverUrl ??
                    'https://via.placeholder.com/800x200', // Default image if null
                fit: BoxFit.cover,
                width: double.infinity,
                height: 40.h,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 40.h,
                  color: Colors.grey[300], // Fallback color
                ),
              ),
              Positioned(
                top: 20.h,
                left: 17.w,
                child: SquareAvatar(
                  imageUrl: company.logoUrl ??
                      'https://via.placeholder.com/100', // Default logo if null
                  size: 60,
                ),
              ),
            ],
          ),
        ),

        // Column containing the rest of the UI elements
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Name and Verification
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Text(
                      company.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (company.isVerified)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(Icons.verified_user_outlined),
                      ),
                  ],
                ),
              ),

              // Company Details (Industry, Location, Followers, Size)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.0,
                  runSpacing: 4.0,
                  children: [
                    Text(
                      company.industry.displayName,
                      style: TextStyle(
                          fontSize: 16.sp, color: Colors.grey.shade600),
                    ),
                    Icon(Icons.circle, size: 6.sp, color: Colors.grey.shade600),
                    Text(
                      company.location ?? "Location not available",
                      style: TextStyle(
                          fontSize: 16.sp, color: Colors.grey.shade600),
                    ),
                    Icon(Icons.circle, size: 6.sp, color: Colors.grey.shade600),
                    Text(
                      "37M followers", // TODO: Replace with actual followers
                      style: TextStyle(
                          fontSize: 16.sp, color: Colors.grey.shade600),
                    ),
                    Icon(Icons.circle, size: 6.sp, color: Colors.grey.shade600),
                    Text(
                      company.organizationSize.displayName,
                      style: TextStyle(
                          fontSize: 16.sp, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              // Action Buttons (Visit Website, Follow, More)
              Padding(
                padding: EdgeInsets.only(top: 12.h, left: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (company.website != null && company.website!.isNotEmpty)
                      VisitCompanyWebsite(
                        text: 'Visit Website',
                        backgroundColor: Color(0xFFD72638),
                        borderColor: Color(0xFFD72638),
                        foregroundColor: Colors.white,
                        icon: Icons.open_in_new,
                        websiteUrl: company.website!,
                        width: 150.w,
                        fontSize: 13.sp,
                      ),
                    SizedBox(width: 8.w),
                    FollowButton(
                      text: "+ Follow",
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFFD72638),
                      borderColor: Color(0xFFD72638),
                      width: 130.w,
                      fontSize: 13.sp,
                    ),
                    CompanyMoreButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
