import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/posts/ui/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Important to control the drawer!
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 1,
        leadingWidth: 0.1.sw,
        leading: IconButton(
          key: Key('home_topBar_profile'),
          iconSize: 30,
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://placehold.co/400/png',
            ),
          ),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Semantics(
            container: true,
            label: 'home_topBar_container',
            child: Center(
              child: Semantics(
                label: 'home_topBar_search',
                child: CustomSearchBar(
                  backgroundColor: ColorsManager.lightGray,
                  keyName: 'home_topBar_search',
                  text: 'Search',
                  onPress: () {
                    Navigator.pushNamed(context, Routes.companyListScreen);
                  },
                  onTextChange: () {},
                  controller: searchController,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Semantics(
            label: 'home_topBar_chatButton',
            child: IconButton(
              icon: const Icon(Icons.message, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, Routes.chatListScreen);
              },
            ),
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.crown, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, Routes.premiumScreen);
            },
          ),
        ],
      ),
      body: Center(
        child: Semantics(
          container: true,
          label: 'home_body_postList',
          child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) => Post(data: mockData),
          ),
        ),
      ),
      bottomNavigationBar: UniversalBottomBar(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Ahmed Hesham'),
            accountEmail: Text('ahmed@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://placehold.co/400/png',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.connect_without_contact_rounded),
            title: const Text('View my connections'),
            onTap: () {
              Navigator.pushNamed(context, Routes.connectionListScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('View all analytics'),
            onTap: () {
              // Add your action here
            },
          ),
          ListTile(
            leading: const Icon(Icons.extension),
            title: const Text('Puzzle games'),
            onTap: () {
              // Add your action here
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Saved posts'),
            onTap: () {
              // Add your action here
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Groups'),
            onTap: () {
              // Add your action here
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Reactivate Premium: 50% Off'),
            onTap: () {
              Navigator.pushNamed(context, Routes.premiumScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, Routes.settingsScreen);
            },
          ),
        ],
      ),
    );
  }
}
