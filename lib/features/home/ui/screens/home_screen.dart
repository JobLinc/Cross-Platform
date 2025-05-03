import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/home/logic/cubit/home_cubit.dart';
import 'package:joblinc/features/home/logic/cubit/home_state.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/ui/widgets/post_list.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../../companypages/data/data/services/getmycompany.dart';
import 'package:joblinc/features/companypages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';

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
        // Get the combined state from the cubit
        final combinedState = context.read<HomeCubit>().combinedState;

        return Scaffold(
          key: _scaffoldKey,
          drawer: _buildDrawer(context, _getUserProfile(combinedState)),
          appBar: _buildAppBar(context, combinedState),
          body: Column(
            children: [
              // Show posts error message if exists
              if (combinedState.postsError != null &&
                  combinedState.postsError!.isNotEmpty)
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    "Posts error: ${combinedState.postsError}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Show user error message if exists
              if (combinedState.userError != null &&
                  combinedState.userError!.isNotEmpty)
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    "Profile error: ${combinedState.userError}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Main content area
              Expanded(
                child: Center(
                  child: _buildPostContent(context, combinedState),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper to get user profile, using a placeholder if not loaded
  UserProfile _getUserProfile(HomeCombinedState state) {
    return state.user ??
        UserProfile(
          username: '',
          isFollowing: false,
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
          confirmed: false,
          role: 0,
          visibility: 'public',
          plan: 0,
          allowMessages: true,
          allowMessageRequests: true,
        );
  }

  // Build the app bar with user profile if available
  AppBar _buildAppBar(BuildContext context, HomeCombinedState state) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leadingWidth: 0.1.sw,
      leading: state.userLoading
          ? _buildShimmerCircle(30) // Show shimmer while loading
          : IconButton(
              key: Key('home_topBar_profile'),
              iconSize: 30,
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  (_getUserProfile(state).profilePicture == null ||
                          _getUserProfile(state).profilePicture == '')
                      ? 'https://placehold.co/400/png'
                      : _getUserProfile(state).profilePicture!,
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
    );
  }

  // Build post content based on loading state
  Widget _buildPostContent(BuildContext context, HomeCombinedState state) {
    if (state.postsLoading) {
      // Show shimmer loading animation for posts
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildPostShimmer(context);
        },
      );
    } else if (state.posts != null) {
      // Show actual posts if available
      return Semantics(
        container: true,
        label: 'home_body_postList',
        child: RefreshIndicator(
          color: ColorsManager.getPrimaryColor(context),
          onRefresh: () async {
            await context.read<HomeCubit>().loadHomeData();
          },
          child: state.posts!.isEmpty
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
              : PostList(posts: state.posts!),
        ),
      );
    } else {
      // Show error placeholder
      return RefreshIndicator(
        color: ColorsManager.getPrimaryColor(context),
        onRefresh: () async {
          await context.read<HomeCubit>().loadPosts();
        },
        child: ListView(
          children: [
            SizedBox(height: 100),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: ColorsManager.getTextSecondary(context),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Couldn't load posts",
                    style: TextStyle(
                      color: ColorsManager.getTextSecondary(context),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Pull down to refresh",
                    style: TextStyle(
                      color: ColorsManager.getTextSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildShimmerCircle(double size) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[700]!,
      highlightColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]!
          : Colors.grey[600]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildShimmerIcon() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[700]!,
      highlightColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]!
          : Colors.grey[600]!,
      child: Container(
        width: 24,
        height: 24,
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPostShimmer(BuildContext context) {
    final shimmerBaseColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey[300]!
        : Colors.grey[700]!;
    final shimmerHighlightColor =
        Theme.of(context).brightness == Brightness.light
            ? Colors.grey[100]!
            : Colors.grey[600]!;
    final backgroundColor = ColorsManager.getCardColor(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // UserHeader section
              Row(
                children: [
                  // Profile image
                  Shimmer.fromColors(
                    baseColor: shimmerBaseColor,
                    highlightColor: shimmerHighlightColor,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Username and headline
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: Container(
                            width: 100,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: Container(
                            width: 150,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // PostBody section - text content
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PostAttachments section - image
              Shimmer.fromColors(
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 10),

              // PostNumerics section - like counts, etc.
              Padding(
                padding:
                    const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
                child: Row(
                  children: [
                    // Likes count with icon
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: Container(
                            width: 20,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // Comments and reposts counts
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: 100,
                        height: 13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Shimmer.fromColors(
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: Container(
                  height: 1,
                  color: Colors.white,
                ),
              ),

              // PostActionBar section - action buttons
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Like button
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Comment button
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Repost button
                    Shimmer.fromColors(
                      baseColor: shimmerBaseColor,
                      highlightColor: shimmerHighlightColor,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
              Navigator.pushNamed(context, Routes.savedPostsScreen);
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
