import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/adminpanel/ui/widgets/map_chart.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Map'),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: TabMenu(),
    );
  }
}

class TabMenu extends StatefulWidget {
  const TabMenu({
    super.key,
  });

  @override
  State<TabMenu> createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TabBar(
                controller: tabController,
                tabs: [
                  ListTile(
                    title: Center(
                      child: Text('map'),
                    ),
                  ),
                  ListTile(
                    title: Center(
                      child: Text('kofta'),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  Center(
                    child: MapChart(),
                  ),
                  Center(
                    child: Image.network(
                        'https://www.allrecipes.com/thmb/A5udb4H7k13lO73TmtiYv_OTQ48=/0x512/filters:no_upscale():max_bytes(150000):strip_icc()/106030-kofta-kebabs-DDMFS-4x3-8d48e28bf518470aba11d076624037a6.jpg'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
