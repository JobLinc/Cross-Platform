import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';

import '../../../data/data/company.dart';

class DashboardAppbar extends StatefulWidget implements PreferredSizeWidget {
  final Company company;
  final Widget? leading;
  final String selectedValue;
  const DashboardAppbar(
      {super.key, required this.company,this.leading,this.selectedValue = "Dashboard"});

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
      leading: widget.leading,
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
                      Navigator.pushNamed(
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
                    case "Analytics":
                      Navigator.pushNamed(
                        context, 
                        Routes.companyAnalytics,
                        arguments: {'company': widget.company},
                      );
                      break;
                    
                    case "Followers":
                      Navigator.pushNamed(context, Routes.companyFollowersListScreen);
                      break;

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
                  'Followers',
                  'Edit Page',
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
