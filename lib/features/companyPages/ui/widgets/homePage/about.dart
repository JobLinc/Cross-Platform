import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';

class CompanyHomeAbout extends StatelessWidget {
  final Company company;

  const CompanyHomeAbout({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (company.website != "" && !company.website!.contains("linkedin"))
            _buildInfoCard('Website', company.website!),
          _buildInfoCard('Industry', company.industry),
          _buildInfoCard('Company size', company.organizationSize),
          _buildInfoCard('Type', company.organizationType),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsManager.crimsonRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
