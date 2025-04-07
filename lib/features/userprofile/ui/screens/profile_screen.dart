import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userprofile/ui/screens/edit_user_profile_screen.dart';
import 'package:joblinc/features/userprofile/data/service/file_pick_service.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        // if (state is ProfilePictureUpdating) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (_) => FullScreenImagePage(imagePath: state.imagepath),
        //     ),
        //   );
        // }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileUpdating) {
          return EditUserProfileScreen();
        }

        if (state is ProfileLoaded) {
          var profile = state.profile;
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () =>
                      context.read<ProfileCubit>().getUserProfile(),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header with cover and profile images
                  _buildProfileHeader(state.profile),

                  // Profile info
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${profile.firstname} ${profile.lastname}',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            // Alternative edit button
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                print('Edit button pressed next to name');
                                Navigator.pushReplacementNamed(
                                    context, Routes.editProfileScreen);
                              },
                              tooltip: 'Edit Profile',
                            ),
                          ],
                        ),

                        SizedBox(height: 8.h),

                        if (profile.headline.isNotEmpty) ...[
                          // Headline
                          Text(
                            profile.headline,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],

                        SizedBox(height: 5.h),

                        Text(
                          '${profile.city}, ${profile.country}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        // TODO: Connection status
                        SizedBox(height: 8),
                        _buildConnectionsInfo(profile),

                        // Profile biography
                        SizedBox(height: 20.h),
                        if (profile.biography.isNotEmpty) ...[
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'About',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                SizedBox(height: 8.h),
                                Text(profile.biography),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ProfilePictureUpdating) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                'Profile photo',
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  // context.read<ProfileCubit>().getUserProfile();
                  BlocProvider.of<ProfileCubit>(context).getUserProfile();
                },
              ),
            ),
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  // Expanded Image Viewer
                  Expanded(
                    child: Center(
                      child: Image.network(
                        "http://${Platform.isAndroid ? "10.0.2.2" : "localhost"}:3000${state.imagepath}",
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey.shade400,
                          );
                        },
                      ),
                    ),
                  ),

                  // Footer with 2 Image Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              // final ProfileCubit profilecubit = context.read<ProfileCubit>();

                              showModalBottomSheet(
                                context: context,
                                builder: (bottomSheetContext) => Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("Tile 1"),
                                        onTap: () async {
                                          File? image =
                                              await pickImage("camera");
                                          // Do something when Tile 1 is tapped
                                          print("Tile 1 tapped");

                                          if (image == null) {
                                            return;
                                          }
                                          context
                                              .read<ProfileCubit>()
                                              .uploadProfilePicture(image!);
                                          Navigator.pop(
                                              bottomSheetContext); // Close the bottom sheet
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text("Tile 2"),
                                        onTap: () async {
                                          File? image =
                                              await pickImage("gallery");
                                          // Do something when Tile 2 is tapped
                                          print("Tile 2 tapped");
                                          context
                                              .read<ProfileCubit>()
                                              .uploadProfilePicture(image!);
                                          // Response response = await getIt<UserProfileRepository>()
                                          //     .uploadProfilePicture(image!);
                                          // print(response.statusCode);
                                          Navigator.pop(
                                              bottomSheetContext); // Close the bottom sheet
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.abc_outlined)),
                        GestureDetector(
                          onTap: () {
                            // Button 2 action
                          },
                          child: IconButton(
                              onPressed: () {}, icon: Icon(Icons.abc_outlined)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Default state or error state
        return Scaffold(
          appBar: AppBar(title: Text('Profile')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No profile data available'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<ProfileCubit>().getUserProfile(),
                  child: Text('Load Profile'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover image
        Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsManager.softRosewood,
                image: profile.coverPicture.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(profile.coverPicture),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
            ),
          ],
        ),

        // Profile image with edit button
        Positioned(
          left: 20,
          top: 100,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent, // Ensures hit testing works
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => BlocProvider<ProfileCubit>(
              //       create: (context) => getIt<
              //           ProfileCubit>(), // Make sure ProfileCubit is created here
              //       child:
              //           FullScreenImagePage(imagePath: profile.profilePicture),
              //     ),
              //   ),
              // );
              // Navigator.pushNamed(context, Routes.profilePictureUpdate,arguments : profile.profilePicture);
              BlocProvider.of<ProfileCubit>(context)
                  .updateprofilepicture(profile.profilePicture);
            },
            child: SizedBox(
              width: 100.r,
              height: 100.r,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.grey.shade200,
                      child: profile.profilePicture.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                "http://${Platform.isAndroid ? "10.0.2.2" : "localhost"}:3000${profile.profilePicture}",
                                fit: BoxFit.cover,
                                width: 96.r,
                                height: 96.r,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 55.r,
                                    color: Colors.grey.shade400,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 55.r,
                              color: Colors.grey.shade400,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionsInfo(UserProfile profile) {
    return GestureDetector(
      child: Row(
        children: [
          Text(
            '${profile.numberOfConnections} connections',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade800,
            ),
          ),
          if (profile.matualConnections > 0) ...[
            Text(' • '),
            Text(
              '${profile.matualConnections} mutual',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.connectionListScreen);
      },
    );
  }
}
