import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';

class TextStyles {
  // Theme-aware text styles that take BuildContext
  static TextStyle font24Bold(BuildContext context) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeightHelper.bold,
        color: ColorsManager.getTextPrimary(context),
      );

  static TextStyle font32Bold(BuildContext context) => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeightHelper.bold,
        color: ColorsManager.getPrimaryColor(context),
      );

  static TextStyle font13SemiBold(BuildContext context) => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeightHelper.semiBold,
        color: ColorsManager.getPrimaryColor(context),
      );

  static TextStyle font13Medium(BuildContext context) => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeightHelper.medium,
        color: ColorsManager.getTextPrimary(context),
      );

  static TextStyle font13Regular(BuildContext context) => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeightHelper.regular,
        color: ColorsManager.getTextPrimary(context),
      );

  static TextStyle font24PrimaryBold(BuildContext context) => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeightHelper.bold,
        color: ColorsManager.getPrimaryColor(context),
      );

  static TextStyle font16WhiteSemiBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorsManager.warmWhite,
  );

  static TextStyle font13GrayRegular(BuildContext context) => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeightHelper.regular,
        color: ColorsManager.getTextSecondary(context),
      );

  static TextStyle font14Regular(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeightHelper.regular,
        color: ColorsManager.getTextSecondary(context),
      );

  static TextStyle font15Medium(BuildContext context) => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeightHelper.medium,
        color: ColorsManager.getTextPrimary(context),
      );

  static TextStyle font18Bold(BuildContext context) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeightHelper.bold,
        color: ColorsManager.getTextPrimary(context),
      );

  static TextStyle font18SemiBold(BuildContext context) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeightHelper.semiBold,
        color: ColorsManager.getTextPrimary(context),
      );

  static TextStyle font18WhiteMedium = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.warmWhite,
  );

  // For backward compatibility, keep the old static styles
  // but gradually migrate to using the theme-aware versions
  static TextStyle font24BlackBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManager.charcoalBlack,
  );

  static TextStyle font32RedBold = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManager.crimsonRed,
  );

  static TextStyle font13RedSemiBold = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.crimsonRed,
  );

  static TextStyle font13DarkBurgundyMedium = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.darkBurgundy,
  );

  static TextStyle font13DarkBurgundyRegular = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.darkBurgundy,
  );

  static TextStyle font24RedBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManager.crimsonRed,
  );

  static TextStyle font12GrayRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.mutedSilver,
  );

  static TextStyle font12GrayMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.mutedSilver,
  );

  static TextStyle font12DarkBurgundyRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.darkBurgundy,
  );

  static TextStyle font12RedRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.crimsonRed,
  );

  static TextStyle font13RedRegular = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.crimsonRed,
  );

  static TextStyle font14GrayRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.mutedSilver,
  );

  static TextStyle font14LightGrayRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.lightGray,
  );

  static TextStyle font14DarkBurgundyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.darkBurgundy,
  );

  static TextStyle font14DarkBurgundyBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManager.darkBurgundy,
  );

  static TextStyle font16WhiteMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.warmWhite,
  );

  static TextStyle font14RedSemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.crimsonRed,
  );

  static TextStyle font15DarkBurgundyMedium = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.darkBurgundy,
  );

  static TextStyle font18DarkBurgundyBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: ColorsManager.darkBurgundy,
  );

  static TextStyle font18DarkBurgundySemiBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.darkBurgundy,
  );
}
