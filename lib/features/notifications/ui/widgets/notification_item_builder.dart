import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_styles.dart';

Widget buildNotificationItem({
    required BuildContext context,
    required String avatar,
    required String name,
    required String action,
    required String time,
    String? subtitle,
    bool isBlueBackground = false,
    bool hasOnlineIndicator = false,
    bool isSpecialIcon = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isBlueBackground
            ? (Theme.of(context).brightness == Brightness.light
                ? const Color.fromARGB(20, 0, 119, 255)
                : const Color.fromARGB(40, 0, 119, 255))
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSpecialIcon
                      ? ColorsManager.lightGray
                      : Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset(
                    avatar,
                    width: 40.w,
                    height: 40.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person,
                      size: 24.sp,
                      color: ColorsManager.getTextSecondary(context),
                    ),
                  ),
                ),
              ),
              if (hasOnlineIndicator)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorsManager.getBackgroundColor(context),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyles.font15Medium(context),
                    children: [
                      TextSpan(
                        text: name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' $action',
                      ),
                    ],
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyles.font13GrayRegular(context),
                  ),
                ],
              ],
            ),
          ),
          Column(
            children: [
              Text(
                time,
                style: TextStyles.font13GrayRegular(context),
              ),
              SizedBox(height: 4.h),
              Icon(
                Icons.more_vert,
                color: ColorsManager.getTextSecondary(context),
                size: 20.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
