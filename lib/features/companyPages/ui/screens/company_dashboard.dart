import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                      // case "Page Posts":
                      //   Navigator.pushNamed(context, Routes.pagePosts);
                      //   break;
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
      body: Center(
        child: Text("Welcome to ${company.name}'s Dashboard"),
      ),
    );
  }
}
