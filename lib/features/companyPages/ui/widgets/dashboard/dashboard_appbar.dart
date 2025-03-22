import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';

import '../../../data/data/company.dart';

class DashboardAppbar extends StatefulWidget implements PreferredSizeWidget {
  final Company company;
  const DashboardAppbar({super.key, required this.company});

  @override
  State<DashboardAppbar> createState() => _DashboardAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(100.0); // Set your preferred height
}

class _DashboardAppbarState extends State<DashboardAppbar> {
  String _selectedValue = "Dashboard"; // State variable to track the selected value

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100.h, // Ensure flutter_screenutil is initialized
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.company.name,
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
                value: _selectedValue, // Bind to the state variable
                onChanged: (String? newValue) {
                  // Update the state when a new value is selected
                  setState(() {
                    _selectedValue = newValue!;
                  });

                  // Handle navigation or other logic based on the selected value
                  switch (newValue) {
                    case "Dashboard":
                      // Already on the dashboard, no action needed
                      break;
                    case "Page Posts":
                      Navigator.pushNamed(
                        context,
                        Routes.companyPagePosts,
                        arguments: widget.company,
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
                padding: EdgeInsets.only(left: 180.w), // Ensure flutter_screenutil is initialized
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement add post logic here Fathy
                  },
                  icon: Icon(Icons.post_add_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}