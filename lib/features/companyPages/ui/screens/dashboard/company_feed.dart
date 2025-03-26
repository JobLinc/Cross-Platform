import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companyPages/ui/widgets/dashboard/dashboard_appbar.dart'
    show DashboardAppbar;

import '../../../data/data/company.dart';

class CompanyFeed extends StatefulWidget {
  final Company company;
  const CompanyFeed({super.key, required this.company});

  @override
  State<CompanyFeed> createState() => _CompanyFeedState();
}

class _CompanyFeedState extends State<CompanyFeed> {
  late String companyName = widget.company.name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppbar(
        company: widget.company,
        selectedValue: "Feed",
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          height: 480.h,
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
                  'assets/images/company_dashboard_img1.svg',
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Center(
                  child: Text(
                    "$companyName can now follow other Pages",
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
                    "Following and engaging with other organizations is a great way to grow your Page's visibility.",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 20.h), 
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement follow functionality
                  },
                  child: Text(
                    'Find Pages to follow',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsManager.crimsonRed,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: ColorsManager.crimsonRed,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ])),
    );
  }
}
