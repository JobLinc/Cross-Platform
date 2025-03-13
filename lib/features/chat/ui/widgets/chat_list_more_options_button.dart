import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => IconButton(
            onPressed: () => showMoreOptions(context),
            icon: Icon(
              Icons.more_vert,
              size: 24.sp,
              color: Colors.white,
            )));
  }
}

void showMoreOptions(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.list),
                title: Text("Manage conversations"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text("Set away messages"),
                subtitle: Text("Unlock with Premium"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Manage settings"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      });
}
