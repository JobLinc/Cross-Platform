import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/userProfile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userProfile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userProfile/ui/screens/edit_user_profile_screen.dart';

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
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileUpdating) {
          return EditUserProfileScreen();
        }

        if (state is ProfileLoaded) {
          final profile = state.profile;
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
                  _buildProfileHeader(profile),

                  // Profile info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${profile.firstname} ${profile.lastname}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                              // Alternative edit button
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  print('Edit button pressed next to name');
                                  Navigator.pushNamed(
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
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
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
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.shade800,
            image: profile.coverPicture.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(profile.coverPicture),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),

        // Profile image with edit button
        Positioned(
          left: 20,
          top: 100,
          child: Container(
            width: 100.r,
            height: 100.r,
            child: GestureDetector(
              child: CircleAvatar(
                radius: 50.r, // Adjust size as needed
                backgroundColor: Colors.grey.shade200,
                child: profile.profilePicture.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          "http://10.0.2.2:3000${profile.profilePicture}",
                          fit: BoxFit.cover,
                          width: 96.r, // Match the radius size
                          height: 96.r, // Match the radius size
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Show the image when loaded
                            } else {
                              return Center(
                                child:
                                    CircularProgressIndicator(), // Show loading indicator
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 55.r,
                              color: Colors.grey.shade400,
                            ); // Show error icon if image fails to load
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 55.r,
                        color: Colors.grey.shade400,
                      ),
              ),
              onTap: () {
                print("hello");
              },
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
