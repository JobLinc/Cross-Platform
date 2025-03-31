import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/userProfile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userProfile/logic/cubit/profile_cubit.dart';

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
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (state is ProfileLoaded) {
          final profile = state.profile;
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => context.read<ProfileCubit>().getUserProfile(),
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
                          Text(
                            '${profile.firstname} ${profile.lastname}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            profile.headline,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          _buildConnectionsInfo(profile),
                          
                          if (profile.about.isNotEmpty) ...[
                            SizedBox(height: 16),
                            Text(
                              'About',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 8),
                            Text(profile.about),
                          ],
                          
                          // Add more sections for experience, education, etc.
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
                  onPressed: () => context.read<ProfileCubit>().getUserProfile(),
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
        
        // Profile image
        Positioned(
          left: 20,
          top: 100,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              image: profile.profilePicture.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(profile.profilePicture),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profile.profilePicture.isEmpty
                ? Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey.shade400,
                  )
                : null,
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
      onTap: (){
        Navigator.pushNamed(context, Routes.connectionListScreen);
      },
    );
  }
}