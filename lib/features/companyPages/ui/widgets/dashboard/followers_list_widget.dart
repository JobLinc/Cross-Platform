import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/connections/logic/cubit/follow_cubit.dart';
import 'package:joblinc/features/userprofile/data/models/follow_model.dart';

class CompanyFollowersListView extends StatelessWidget {
  final List<Follow> followers;
  final bool isfollowing;
  const CompanyFollowersListView(
      {Key? key, required this.followers, this.isfollowing = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: followers.length,
      itemBuilder: (context, index) {
        final follower = followers[index];

        return Container(
          color: Colors.white,
          child: InkWell(
            onTap: () async {
                print(
                    "Go to user profile: ${follower.firstname} ${follower.lastname}");
                final refresh = await Navigator.pushNamed(
                    context, Routes.otherProfileScreen,
                    arguments: follower.userId);
                if (refresh == true) {
                  if (isfollowing) {
                    context.read<FollowCubit>().fetchFollowing();
                  } else {
                    context.read<FollowCubit>().fetchFollowers();
                  }
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ProfileImage(
                    imageURL: follower.profilePicture,
                    radius: 25.r,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         "${follower.firstname} ${follower.lastname}",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (follower.headline.isNotEmpty)
                        Text(
                          follower.headline,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      SizedBox(height: 4.h),

                    ],
                  ),
                ),
                 IconButton(
                        onPressed: () {
                            context
                                .read<FollowCubit>()
                                .removeFollower(follower.userId, context);
                        },
                        icon: Icon(Icons.person_remove, size: 20.sp),
                      )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        thickness: 1,
        height: 0,
      ),
    );
  }
}
