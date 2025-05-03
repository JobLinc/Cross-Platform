import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/posts/ui/widgets/post_list.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_posts_cubit.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_posts_state.dart';

class OthersUserProfilePosts extends StatelessWidget {
  final String userId;
  const OthersUserProfilePosts({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProfilePostsCubit>()..loadOthersProfilePosts(userId),
      child: BlocBuilder<ProfilePostsCubit, ProfilePostsState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Posts',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (state is ProfilePostsLoaded && state.posts.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            context
                                .read<ProfilePostsCubit>()
                                .loadOthersProfilePosts(userId);
                          },
                          child: Text('Refresh'),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                _buildContent(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfilePostsState state) {
    if (state is ProfilePostsLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is ProfilePostsLoaded) {
      if (state.posts.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.post_add, size: 48.sp, color: Colors.grey),
                SizedBox(height: 8.h),
                Text(
                  'No posts yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

      return Container(
        height: 400.h, // Fixed height container for posts
        child: PostList(
          posts: state.posts,
          showOwnerMenu: false,
        ),
      );
    } else if (state is ProfilePostsError) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
              SizedBox(height: 8.h),
              Text(
                'Failed to load posts',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () {
                  context
                      .read<ProfilePostsCubit>()
                      .loadOthersProfilePosts(userId);
                },
                child: Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }
}
