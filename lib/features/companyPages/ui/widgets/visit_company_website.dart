import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart'; 

Widget VisitCompanyWebsite({
  required String text,
  required Color backgroundColor,
  IconData? icon,
  required Color foregroundColor,
  Color? borderColor,
  double? width,
  double? fontSize,
  double? borderRadius,
  EdgeInsets? padding,
  required String websiteUrl, 
}) {
  return GestureDetector(
    onTap: () async {
      final Uri uri = Uri.parse(websiteUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $websiteUrl';
      }
    },
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
              : Icon(icon, color: foregroundColor), // Icon
          icon == null
              ? SizedBox()
              : SizedBox(width: 10.sp), // Reduce space between icon and text
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