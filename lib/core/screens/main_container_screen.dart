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
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  // Handle result from post creation
  Future<void> _navigateToAddPost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => getIt<AddPostCubit>(),
          child: AddPostScreen(),
        ),
      ),
    );

    // If result is 0, navigate to home tab
    if (result == 0) {
      _onItemTapped(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Now we build the screens with context available
    return Scaffold(
      appBar: _getAppBarForIndex(_selectedIndex, context),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home tab
          _buildKeepAliveScreen(
            BlocProvider(
              create: (context) => getIt<HomeCubit>()..getUserInfo(),
              child: const HomeScreen(),
            ),
          ),

          // Network tab
          _buildKeepAliveScreen(
            BlocProvider(
              create: (context) => getIt<InvitationsCubit>(),
              child: const InvitationsTabs(key: Key("connections home screen")),
            ),
          ),

          // Post tab
          _buildKeepAliveScreen(
            BlocProvider(
                create: (context) => getIt<AddPostCubit>(),
                child: AddPostScreen()),
          ),

          // Notifications tab - use the actual NotificationsScreen instead of placeholder
          _buildKeepAliveScreen(
            const NotificationsScreen(),
          ),

          // Jobs tab
          _buildKeepAliveScreen(
            BlocProvider(
              create: (context) => getIt<JobListCubit>(),
              child: const JobListScreen(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: UniversalBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Helper to get the right AppBar for each tab
  PreferredSizeWidget? _getAppBarForIndex(int index, BuildContext context) {
    // Some tabs like HomeScreen have their own AppBar, return null for those
    if (index == 0) return null; // HomeScreen has its own AppBar

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

  // Wraps a screen in a KeepAlive widget
  Widget _buildKeepAliveScreen(Widget screen) {
    return _KeepAliveWrapper(child: screen);
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

// Keep alive wrapper to preserve the state of each tab
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
