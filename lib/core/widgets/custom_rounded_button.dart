import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customRoundedButton({
  required String text,
  required Color backgroundColor,
  IconData? icon,
  required GestureTapCallback onPressed,
  required Color foregroundColor,
  Color? borderColor,
  double? width,
  double? fontSize,
  double? borderRadius,
  EdgeInsets? padding,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      alignment: Alignment.center,
      padding: padding ?? EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 40),
          border: Border.all(color: borderColor ?? Colors.black, width: 1.5),
          color: backgroundColor),
      width: width ?? 0.85.sw,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon == null
              ? SizedBox()
              : Icon(icon, color: foregroundColor), // Icon
          icon == null
              ? SizedBox()
              : SizedBox(width: 20.sp), // Space between icon and text
          Text(
            text,
            style:
                TextStyle(color: foregroundColor, fontSize: fontSize ?? 18.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
