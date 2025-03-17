import 'package:flutter/material.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScrollableTabs extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const ScrollableTabs({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  State<ScrollableTabs> createState() => _ScrollableTabsState();
}

class _ScrollableTabsState extends State<ScrollableTabs> {
  final List<String> _tabs = [
    'Home',
    'About',
    'Posts',
    'Jobs',
    'People',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final int index = entry.key;
          final String title = entry.value;

          return InkWell(
            onTap: () => widget.onTabSelected(index),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: widget.selectedIndex == index
                        ? ColorsManager.crimsonRed
                        : Colors.transparent,
                    width: 2.w,
                  ),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: widget.selectedIndex == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: widget.selectedIndex == index
                      ? ColorsManager.crimsonRed
                      : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
