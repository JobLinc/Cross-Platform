import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/features/companypages/data/data/repos/companyjobs_repo.dart';
import 'package:joblinc/features/companypages/data/data/services/companyjobs_api.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';
import 'package:joblinc/core/di/dependency_injection.dart';

class CompanyHomeJobs extends StatelessWidget {
  final String companyId;
  final bool isAdmin;
  const CompanyHomeJobs(
      {required this.companyId, this.isAdmin = false, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: GetCompanyJobsRepo(
        GetCompanyJobsApiService(companyId, getIt<Dio>()),
      ).getCompanyJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load jobs',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return JobList(
              jobs: snapshot.data!,
              isCreated: true,
              isCompanyPageAdmin: isAdmin);
        } else {
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
                      "No jobs yet",
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
                      "Check back later for jobs!",
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
      },
    );
  }
}
