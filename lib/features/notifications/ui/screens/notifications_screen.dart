import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_styles.dart';
import 'package:joblinc/features/notifications/ui/widgets/notification_item_builder.dart';
import 'package:joblinc/features/notifications/ui/widgets/notifications_list_builder.dart';
import 'package:joblinc/features/notifications/ui/widgets/tab_bar_builder.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Jobs', 'My posts', 'Mentions'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTabBar(
          context: context,
          tabController: _tabController,
          tabs: _tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) {
              return buildNotificationsList(context: context);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
