import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/home/logic/cubit/home_cubit.dart';
import 'package:joblinc/features/home/logic/cubit/home_state.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
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
        } else if (state is HomePostsFailure || state is HomeLoaded) {
          UserProfile? user;
          List<PostModel>? posts;
          String? errorMessage;

          if (state is HomeLoaded) {
            user = state.user;
            posts = state.posts;
          } else if (state is HomePostsFailure) {
            user = state.user;
            posts = state.posts;
            errorMessage = state.error;
          }

          user ??= UserProfile(
            userId: '',
            profilePicture: "",
            coverPicture: "",
            headline: '',
            country: '',
            city: '',
            biography: '',
            email: 'Unable to load profile',
            firstname: 'Guest',
            lastname: 'User',
            phoneNumber: '',
            connectionStatus: 'none',
            numberOfConnections: 0,
            matualConnections: 0,
            recentPosts: [],
            skills: [],
            education: [],
            experiences: [],
            certifications: [],
            languages: [],
            resumes: [],
          );

          posts ??= [];

          return Scaffold(
            key: _scaffoldKey,
            drawer: _buildDrawer(context, user),
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
                    (user.profilePicture == null || user.profilePicture == '')
                        ? 'https://placehold.co/400/png'
                        : user.profilePicture!,
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
            body: Column(
              children: [
                if (errorMessage != null && errorMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Semantics(
                      container: true,
                      label: 'home_body_postList',
                      child: RefreshIndicator(
                        color: ColorsManager.getPrimaryColor(context),
                        onRefresh: () async {
                          await context.read<HomeCubit>().getFeed();
                        },
                        child: posts.isEmpty
                            ? ListView(
                                children: [
                                  SizedBox(height: 100),
                                  Center(
                                    child: Text(
                                      "No posts available",
                                      style: TextStyle(
                                        color: ColorsManager.getTextSecondary(context),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : PostList(posts: posts),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text(
              "Unknown state occurred",
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
                '${myUser.firstname ?? ''} ${myUser.lastname ?? ''}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              accountEmail: Text(
                myUser.email ?? '',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  (myUser.profilePicture == null || myUser.profilePicture == '')
                      ? 'https://placehold.co/400/png'
                      : myUser.profilePicture!,
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
