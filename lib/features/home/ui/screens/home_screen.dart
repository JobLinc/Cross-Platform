import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/home/logic/cubit/home_cubit.dart';
import 'package:joblinc/features/posts/ui/widgets/post_list.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/companyPages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/features/companyPages/data/data/services/getmycompany.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';

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
                    (myUser.profilePicture == null ||
                            myUser.profilePicture == '')
                        ? 'https://placehold.co/400/png'
                        : myUser.profilePicture!,
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
                    await context.read<HomeCubit>().getFeed();
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
          // --- My Companies Section ---
          FutureBuilder<List<Company>>(
            future: CompanyRepositoryImpl(
              CompanyApiService(getIt<Dio>()),
            ).getCurrentCompanies(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Loading companies...'),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Failed to load companies'),
                  subtitle: Text('${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final companies = snapshot.data!;
                if (companies.isEmpty) {
                  return SizedBox.shrink();
                }
                return ExpansionTile(
                  leading: const Icon(Icons.business),
                  title: const Text('My Companies'),
                  children: companies
                      .map((company) => ListTile(
                            leading: const Icon(Icons.apartment),
                            title: Text(company.name),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.companyPageHome,
                                arguments: {
                                  'company': company,
                                  'isAdmin': true
                                },
                              );
                            },
                          ))
                      .toList(),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          // --- End My Companies Section ---
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
