import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';

import '../../../data/data/company.dart';

class DashboardAppbar extends StatefulWidget implements PreferredSizeWidget {
  final Company company;
  final String selectedValue;
  const DashboardAppbar(
      {super.key, required this.company, this.selectedValue = "Dashboard"});

  @override
  State<DashboardAppbar> createState() => _DashboardAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}

class _DashboardAppbarState extends State<DashboardAppbar> {
  late String _selectedValue = widget.selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100.h,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.company.name,
                style: TextStyle(
                  fontSize: 20.sp,
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
                  _selectedValue = newValue!;
                  // Handle navigation or other logic based on the selected value
                  switch (newValue) {
                    case "Dashboard":
                      _selectedValue = "Dashboard";
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.companyDashboard,
                        arguments: widget.company,
                      );

                      break;
                    case "Company Profile":
                      _selectedValue = "Company Profile";
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.companyPageHome,
                        arguments: {'company': widget.company, 'isAdmin': true}
                      );

                      break;
                    // case "Analytics":
                    //   Navigator.pushNamed(context, Routes.analytics);
                    //   break;
                    case "Feed":
                      _selectedValue = "Feed";
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.companyFeed,
                        arguments: widget.company,
                      );
                      break;
                    // case "Inbox":
                    //   Navigator.pushNamed(context, Routes.inboxPage);
                    //   break;
                    case "Edit Page":
                      Navigator.pushNamed(
                        context, 
                        Routes.companyEdit,
                        arguments: widget.company,
                      );
                      break;
                    // case "Jobs":
                    //   Navigator.pushNamed(context, Routes.jobsPage);
                    //   break;
                  }
                },
                items: <String>[
                  'Dashboard',
                  'Company Profile',
                  'Analytics',
                  'Feed',
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
              
            ],
          ),
        ],
      ),
    );
  }
}
