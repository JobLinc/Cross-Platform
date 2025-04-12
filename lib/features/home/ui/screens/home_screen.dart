import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/home/logic/cubit/home_cubit.dart';
import 'package:joblinc/features/posts/ui/widgets/post_list.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

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
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomePostsLoading) {
          return Scaffold(
              body: Container(
                  color: ColorsManager.getBackgroundColor(context),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: ColorsManager.getPrimaryColor(context),
                  ))));
        } else if (state is HomePostsFailure) {
          return Center(
            child: Text(
              state.error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        } else if (state is HomeLoaded) {
          // Assuming you have a user object in the state
          final myUser = state.user;
          return Scaffold(
            key: _scaffoldKey, // Important to control the drawer!
            drawer: _buildDrawer(context, myUser),
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
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
                    myUser.profilePicture == ''
                        ? 'https://placehold.co/400/png'
                        : "http://${Platform.isAndroid ? "10.0.2.2" : "localhost"}:3000${myUser.profilePicture}",
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
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.light
                                ? ColorsManager.lightGray
                                : ColorsManager.darkModeCardBackground,
                        keyName: 'home_topBar_search',
                        text: 'Search',
                        onPress: () {
                          Navigator.pushNamed(
                              context, Routes.companyListScreen);
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
                    icon: Icon(Icons.message,
                        color: ColorsManager.getTextPrimary(context)),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.chatListScreen);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.crown,
                      color: ColorsManager.getTextPrimary(context)),
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
                child: RefreshIndicator(
                  color: ColorsManager.getPrimaryColor(context),
                  onRefresh: () async {
                    // Call cubit to refresh the feed data
                    await context.read<HomeCubit>().getUserInfo();
                  },
                  child: PostList(posts: state.posts),
                ),
              ),
            ),
            // Removed the bottom navigation bar as it's now handled by MainContainerScreen
          );
        } else {
          return Center(
            child: Text(
              "error occured",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }
      },
    );
  }

  Widget _buildDrawer(BuildContext context, UserProfile myUser) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.profileScreen);
            },
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              accountName: Text(
                '${myUser.firstname} ${myUser.lastname}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              accountEmail: Text(
                myUser.email,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  myUser.profilePicture == ''
                      ? 'https://placehold.co/400/png'
                      : "http://${Platform.isAndroid ? "10.0.2.2" : "localhost"}:3000${myUser.profilePicture}",
                ),
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
