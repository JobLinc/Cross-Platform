import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';

Widget buildTabBar({
  required BuildContext context,
  required TabController tabController,
  required List<String> tabs,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1.0,
        ),
      ),
    ),
    child: TabBar(
      controller: tabController,
      isScrollable: true,
      labelColor: ColorsManager.getPrimaryColor(context),
      unselectedLabelColor: ColorsManager.getTextSecondary(context),
      indicatorColor: ColorsManager.getPrimaryColor(context),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: tabs.map((tab) {
        return Tab(
          child: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Text(
              tab,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
