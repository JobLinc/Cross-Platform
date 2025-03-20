import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Widget FollowButton({
  required String text,
  required Color backgroundColor,
  IconData? icon,
  required Color foregroundColor,
  Color? borderColor,
  double? width,
  double? fontSize,
  double? borderRadius,
  EdgeInsets? padding,
}) {
  return GestureDetector(
    onTap: () {}, // TODO : Implement the onTap function
    child: Container(
      alignment: Alignment.center,
      padding: padding ?? EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Adjust padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 40),
        border: Border.all(color: borderColor ?? Colors.black, width: 1.5),
        color: backgroundColor,
      ),
      width: width ?? 200, 
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon == null
              ? SizedBox()
              : Icon(icon, color: foregroundColor), 
          icon == null
              ? SizedBox()
              : SizedBox(width: 10.sp), 
          Text(
            text,
            style: TextStyle(
              color: foregroundColor,
              fontSize: fontSize ?? 16.sp, 
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}