import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/universal_app_bar_widget.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/connections/logic/cubit/invitations_cubit.dart';
import 'package:joblinc/features/connections/ui/screens/InvitationPage.dart';
import 'package:joblinc/features/connections/ui/screens/Recieved_Sent_Tabs.dart';
import 'package:joblinc/features/home/logic/cubit/home_cubit.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_state.dart';
import 'package:joblinc/features/notifications/ui/screens/notifications_screen.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_cubit.dart';
import 'package:joblinc/features/posts/ui/screens/add_post.dart';

class MainContainerScreen extends StatefulWidget {
  final int initialTab;

  const MainContainerScreen({
    Key? key,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  _MainContainerScreenState createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late TabController _tabController;
  int _unseenNotificationCount = 0; // Track unseen notification count
  late NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: _selectedIndex,
    );

    // Sync tab controller with page controller
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });

        // Only mark notifications as read when actively switching to the tab
        if (_selectedIndex == 3 && _notificationCubit != null) {
          _notificationCubit.markAllAsSeen();
        }
      }
    });

    // Initialize notification cubit to listen for updates across the app
    _notificationCubit = getIt<NotificationCubit>();

    // Initialize notification services and fetch initial count
    // But don't mark as read
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationCubit.initServices();
      _fetchUnseenCount();

      // Prevent keyboard from showing up automatically
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  // Fetch the count of unseen notifications
  Future<void> _fetchUnseenCount() async {
    final count = await _notificationCubit.getUnseenCount();
    setState(() {
      _unseenNotificationCount = count;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Prevent keyboard from showing up automatically
      FocusManager.instance.primaryFocus?.unfocus();
    });
    // Only if we're not already on this tab
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        _tabController.animateTo(index);

        // Reset notification count when navigating to notifications tab
        if (index == 3) {
          _unseenNotificationCount = 0;

          // Mark as seen only when user explicitly taps the notifications tab
          if (_notificationCubit != null) {
            _notificationCubit.markAllAsSeen();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      bloc: _notificationCubit,
      listener: (context, state) {
        if (state is NotificationLoaded) {
          // Only count and update if we're not on the notifications tab
          if (_selectedIndex != 3) {
            final unseenCount =
                state.notifications.where((n) => n.isRead == "pending").length;

            if (unseenCount != _unseenNotificationCount) {
              setState(() {
                _unseenNotificationCount = unseenCount;
              });
            }
          }
        }
      },
      child: Scaffold(
        appBar: _getAppBarForIndex(_selectedIndex, context),
        body: _buildCurrentTabContent(_selectedIndex),
        bottomNavigationBar: UniversalBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          notificationCount: _unseenNotificationCount,
        ),
      ),
    );
  }

  // Build only the current tab's content
  Widget _buildCurrentTabContent(int index) {
    switch (index) {
      case 0:
        // Home tab
        return BlocProvider(
          create: (context) => getIt<HomeCubit>()..getFeed(),
          child: const HomeScreen(),
        );
      case 1:
        // Network tab
        return BlocProvider(
          create: (context) => getIt<InvitationsCubit>(),
          child: const InvitationsTabs(key: Key("connections home screen")),
        );
      case 2:
        // Post tab
        return BlocProvider(
          create: (context) => getIt<AddPostCubit>(),
          child: AddPostScreen(),
        );
      case 3:
        // Notifications tab
        return BlocProvider.value(
          value: _notificationCubit,
          child: const NotificationsScreen(),
        );
      case 4:
        // Jobs tab
        return BlocProvider(
          create: (context) => getIt<JobListCubit>(),
          child: const JobListScreen(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // Helper to get the right AppBar for each tab
  PreferredSizeWidget? _getAppBarForIndex(int index, BuildContext context) {
    // Some tabs like HomeScreen have their own AppBar, return null for those
    if (index == 0 || index == 2)
      return null; // HomeScreen has its own AppBar and Add Post tab has no AppBar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Prevent keyboard from showing up automatically
      FocusManager.instance.primaryFocus?.unfocus();
    });
    // For Jobs tab, include search functionality
    if (index == 4) {
      return universalAppBar(
        context: context,
        selectedIndex: index,
        searchBarFunction: () =>
            Navigator.pushNamed(context, Routes.jobSearchScreen),
      );
    }

    // Default AppBar for other tabs
    return universalAppBar(
      context: context,
      selectedIndex: index,
    );
  }

  // Method to build placeholder screens
  Widget _buildPlaceholderScreen(String title, int index) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            index == 2 ? Icons.post_add : Icons.notifications_none,
            size: 64,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade400
                : Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            index == 2 ? "Create Post" : "No New Notifications",
            style: TextStyle(
              fontSize: 20,
              color: ColorsManager.getTextPrimary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            index == 2
                ? "Share updates with your network"
                : "You're all caught up!",
            style: TextStyle(
              color: ColorsManager.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
