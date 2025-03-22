import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';

class CompanyDashboard extends StatelessWidget {
  final Company company;

  const CompanyDashboard({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.h,
        title: Column(
          children: [
            // First Row: Company Title and Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  company.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        // Navigate to notifications page
                        // Example: Navigator.pushNamed(context, Routes.notificationsPage);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.mail),
                      onPressed: () {
                        // Navigate to inbox page
                        // Example: Navigator.pushNamed(context, Routes.inboxPage);
                      },
                    ),
                  ],
                ),
              ],
            ),
            // Second Row: Dropdown Button
            Row(
              children: [
                DropdownButton<String>(
                  value: "Dashboard", // Default value
                  onChanged: (String? newValue) {
                    // Handle dropdown item selection
                    switch (newValue) {
                      case "Dashboard":
                        // Already on the dashboard, no action needed
                        break;
                      case "Page Posts":
                        print("Navigating to Page Posts");
                        Navigator.pushNamed(
                          context, 
                          Routes.companyPagePosts,
                          arguments: company,
                        );
                        break;
                      // case "Analytics":
                      //   Navigator.pushNamed(context, Routes.analytics);
                      //   break;
                      // case "Inbox":
                      //   Navigator.pushNamed(context, Routes.inboxPage);
                      //   break;
                      // case "Edit Page":
                      //   Navigator.pushNamed(context, Routes.editPage);
                      //   break;
                      // case "Jobs":
                      //   Navigator.pushNamed(context, Routes.jobsPage);
                      //   break;
                    }
                  },
                  items: <String>[
                    'Dashboard',
                    'Page Posts',
                    'Analytics',
                    'Inbox',
                    'Edit Page',
                    'Jobs',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 180.w),
                  child: IconButton(
                      onPressed: () {} //TODO: Implement add post for Fathy
                      ,
                      icon: Icon(Icons.post_add_rounded)),
                )
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 470.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Manage recent posts",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Keep tabs on your page's recent content",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  SizedBox(height: 16.h),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/company_dashboard_img1.svg',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 90.w),
                    child: Center(
                      child: Text(
                        "Your page doesn't have any posts from the last 90 days",
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 90.w),
                    child: Center(
                      child: Text(
                        "Pages that post 2x a week grow 5x faster",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h), // Add spacing between elements
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement Add Post functionality Fathy
                      },
                      child: Text(
                        'Start a post',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsManager.crimsonRed,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
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
            SizedBox(height: 16.h),
            Container(
              height: 470.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Join conversations",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Build brand awareness and community by engaging with recent conversations",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  SizedBox(height: 16.h),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/company_dashboard_img2.svg',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 90.w),
                    child: Center(
                      child: Text(
                        "Your feed is empty",
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 90.w),
                    child: Center(
                      child: Text(
                        "Follow other pages in your industry to get new content inspiration",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h), // Add spacing between elements
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: Add functionality to follow other pages
                      },
                      child: Text(
                        'Add pages to follow',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsManager.crimsonRed,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
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
          ],
        ),
      ),
    );
  }
}
