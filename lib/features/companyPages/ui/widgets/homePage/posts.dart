import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CompanyHomePosts extends StatelessWidget {
  const CompanyHomePosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          height: 200.h,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/images/company_dashboard_img2.svg',
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Center(
                  child: Text(
                    "No posts yet",
                    style: TextStyle(
                      fontSize: 24.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 65.w),
                child: Center(
                  child: Text(
                    "Check back later for posts!",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ), 
            ],
          ),
        );
  }
}