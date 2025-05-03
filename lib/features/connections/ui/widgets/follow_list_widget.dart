import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/connections/logic/cubit/follow_cubit.dart';
import 'package:joblinc/features/userprofile/data/models/follow_model.dart';

class FollowListView extends StatelessWidget {
  final List<Follow> follows;
  final bool isfollowing;
  const FollowListView(
      {Key? key, required this.follows, this.isfollowing = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: follows.length,
      itemBuilder: (context, index) {
        final follow = follows[index];
        final isCompany = follow.companyId != null;

        return Container(
          color: Colors.white,
          child: InkWell(
            onTap: () async {
              if (isCompany) {
                print("Go to company profile: ${follow.companyName}");
              } else {
                print(
                    "Go to user profile: ${follow.firstname} ${follow.lastname}");
                final refresh = await Navigator.pushNamed(
                    context, Routes.otherProfileScreen,
                    arguments: follow.userId);
                if (refresh == true) {
                  if (isfollowing) {
                    context.read<FollowCubit>().fetchFollowing();
                  } else {
                    context.read<FollowCubit>().fetchFollowers();
                  }
                }
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ProfileImage(
                    imageURL: isCompany
                        ? (follow.companyLogo ?? '')
                        : (follow.profilePicture),
                    radius: 25.r,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCompany
                            ? (follow.companyName ?? "Unnamed Company")
                            : "${follow.firstname} ${follow.lastname}",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!isCompany && follow.headline.isNotEmpty)
                        Text(
                          follow.headline,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      SizedBox(height: 4.h),
                      Text(
                        "Followed on: ${DateFormat.yMMMd().format(follow.time)}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                isfollowing
                    ? IconButton(
                        onPressed: () {
                          // TODO: Show bottom modal to unfollow
                          print("Unfollow");
                          if (!isCompany) {
                            context
                                .read<FollowCubit>()
                                .unfollowConnection(follow.userId, context);
                          } else {
                            context
                                .read<FollowCubit>()
                                .unfollowConnection(follow.companyId!, context);
                          }
                        },
                        icon: Icon(Icons.person_remove, size: 20.sp),
                      )
                    : SizedBox.shrink(),
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
