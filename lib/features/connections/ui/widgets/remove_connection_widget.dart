import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';

class removeSheet extends StatelessWidget {
  const removeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.sp),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: ListTile(
          leading: Icon(Icons.person_remove, color: ColorsManager.darkBurgundy),
          title: Text("Remove connection"),
        ),
      ),
    );
  }
}
