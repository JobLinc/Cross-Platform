import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';

class CompanyPagePosts extends StatelessWidget {
  final Company company;

  const CompanyPagePosts({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // TODO: Add a list view of posts
          Container(
            height: 200.h,
            color: Colors.white,
            child: const Center(
              child: Text("Posts"),
            ),
          ),
        ],
      ),
    );
  }
}