import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SnackBarType { success, error, info }

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);

    // Define colors and icons based on type
    Color backgroundColor;
    Icon icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor =
            const Color.fromARGB(255, 76, 175, 80); // Material Green 500
        icon = Icon(Icons.check_circle_outline, color: Colors.white);
        break;
      case SnackBarType.error:
        backgroundColor =
            const Color.fromARGB(255, 218, 14, 14); // Material Red 700
        icon = Icon(Icons.error_outline, color: Colors.white);
        break;
      case SnackBarType.info:
        backgroundColor =
            const Color.fromARGB(255, 0, 122, 255); // Material Blue 500
        icon = Icon(Icons.info_outline, color: Colors.white);
        break;
    }

    // Create and show SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 60.sp, left: 20.sp, right: 20.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.sp),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        content: Row(
          children: [
            icon,
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
