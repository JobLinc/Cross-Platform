import 'package:flutter/material.dart';
import '../../../../core/theming/colors.dart';

class ScrollableTabs extends StatelessWidget {
  final TabController tabController;

  const ScrollableTabs({required this.tabController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        isScrollable: false, 
        labelColor: ColorsManager.crimsonRed,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: ColorsManager.crimsonRed,
        tabs: const [
          Tab(
            child: Text(
              "Home",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ),
          Tab(
            child: Text(
              "About",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ),
          Tab(
            child: Text(
              "Posts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ),
          Tab(
            child: Text(
              "Jobs",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ),
          Tab(
            child: Text(
              "People",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ),
        ],
      ),
    );
  }
}
