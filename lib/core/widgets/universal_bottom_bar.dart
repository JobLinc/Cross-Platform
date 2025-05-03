import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';

class UniversalBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int notificationCount; // Add notification count parameter

  const UniversalBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.notificationCount = 0, // Default to 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsManager.darkModeCardBackground
            : Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Semantics(
          container: true,
          label: 'core_bottombar_container',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                thickness: 0.5,
                height: 0,
                color: isDarkMode
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.3),
              ),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(context, 0, Icons.home, 'Home'),
                    _buildNavItem(context, 1, Icons.people, 'Network'),
                    _buildNavItem(context, 2, Icons.add_box, 'Post'),
                    _buildNavItem(context, 3, Icons.notifications, 'Alerts'),
                    _buildNavItem(context, 4, Icons.work, 'Jobs'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Choose colors based on theme and selection state
    final selectedColor =
        isDarkMode ? ColorsManager.darkCrimsonRed : ColorsManager.darkBurgundy;

    final unselectedColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    final backgroundColor = isSelected
        ? (isDarkMode
            ? selectedColor.withOpacity(0.15)
            : selectedColor.withOpacity(0.1))
        : Colors.transparent;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    color: isSelected ? selectedColor : unselectedColor,
                    size: isSelected ? 26 : 24,
                  ),
                ),
                // Show notification badge only for notifications tab (index 3)
                if (index == 3 && notificationCount > 0)
                  Positioned(
                    top: -5,
                    right: -8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationCount > 99 ? '99+' : '$notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? selectedColor : unselectedColor,
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected
                    ? FontWeightHelper.semiBold
                    : FontWeightHelper.regular,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

void goToJobSearch(BuildContext context) {
  Navigator.pushNamed(context, Routes.jobSearchScreen);
}

void emptyFunction() {}
