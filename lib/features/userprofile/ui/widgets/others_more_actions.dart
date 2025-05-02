import 'package:flutter/material.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import this package

void showModalBasedOnConnectionStatus(
    BuildContext context,
    String connectionStatus,
    ProfileCubit cubit,
    String userId,
    bool isFollowing) {
  switch (connectionStatus) {
    case 'Accepted':
      showMessageModal(
          context, cubit, userId); // Shows block & remove connection
      break;
    case 'Received':
      showSentModal(context, cubit, userId,
          isFollowing); // (You will define it: Accept / Reject)
      break;
    case 'Sent':
      showSentModal(context, cubit, userId,
          isFollowing); // (You already have it: Withdraw request)
      break;
    case 'Blocked':
      //showBlockedModal(context); // (You can design this — maybe only unblock?)
      break;
    case 'Not Connected':
      showSentModal(context, cubit, userId,
          isFollowing); // (Maybe a simple connect button)
      break;
    default:
      // Maybe do nothing or show a snackbar
      break;
  }
}

void showMessageModal(BuildContext context, ProfileCubit cubit, String userId) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r)), // Make the radius responsive
    ),
    backgroundColor: Colors.white,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 24.w, vertical: 32.h), // Responsive padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat,
                size: 48.sp, color: Colors.blueAccent), // Responsive icon size
            SizedBox(height: 16.h),
            Text(
              "Manage Connection",
              style: TextStyle(
                fontSize: 22.sp, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Block Button
                GestureDetector(
                  onTap: () {
                    // TODO: add block functionality
                    Navigator.of(context).pop();
                    cubit.blockConnection(userId, context);
                  },
                  child: Container(
                    width: 120.w, // Responsive width
                    padding: EdgeInsets.symmetric(
                        vertical: 14.h), // Responsive padding
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius:
                          BorderRadius.circular(16.r), // Responsive radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 8.r, // Responsive blur radius
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.block,
                            color: Colors.white,
                            size: 32.sp), // Responsive icon size
                        SizedBox(height: 8.h),
                        Text(
                          "Block",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Remove Connection Button
                GestureDetector(
                  onTap: () {
                    // TODO: add remove connection functionality
                    Navigator.of(context).pop();
                    cubit.removeConnection(userId, context);
                  },
                  child: Container(
                    width: 120.w, // Responsive width
                    padding: EdgeInsets.symmetric(
                        vertical: 14.h), // Responsive padding
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius:
                          BorderRadius.circular(16.r), // Responsive radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 8.r, // Responsive blur radius
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_remove,
                            color: Colors.white,
                            size: 32.sp), // Responsive icon size
                        SizedBox(height: 8.h),
                        Text(
                          "Remove",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      );
    },
  );
}

void showSentModal(
    BuildContext context, ProfileCubit cubit, String userId, bool isFollowing) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24.r), // Responsive top radius
      ),
    ),
    backgroundColor: Colors.white,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 24.w, vertical: 32.h), // Responsive padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat,
                size: 48.sp, color: Colors.blueAccent), // Responsive icon size
            SizedBox(height: 16.h),
            Text(
              "Manage Connection",
              style: TextStyle(
                fontSize: 22.sp, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Block Button
                GestureDetector(
                  onTap: () {
                    // TODO: add block functionality
                    Navigator.of(context).pop();
                    cubit.blockConnection(userId, context);
                  },
                  child: Container(
                    width: 120.w, // Responsive width
                    padding: EdgeInsets.symmetric(
                        vertical: 14.h), // Responsive padding
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius:
                          BorderRadius.circular(16.r), // Responsive radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 8.r, // Responsive blur radius
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.block,
                            color: Colors.white,
                            size: 32.sp), // Responsive icon size
                        SizedBox(height: 8.h),
                        Text(
                          "Block",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Follow/Unfollow Button
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (isFollowing) {
                      cubit.unfollowConnection(userId, context);
                    } else {
                      cubit.followConnection(userId, context);
                    }
                  },
                  child: Container(
                    width: 120.w, // Responsive width
                    padding: EdgeInsets.symmetric(
                        vertical: 14.h), // Responsive padding
                    decoration: BoxDecoration(
                      color: isFollowing
                          ? Colors.orangeAccent
                          : Colors.greenAccent,
                      borderRadius:
                          BorderRadius.circular(16.r), // Responsive radius
                      boxShadow: [
                        BoxShadow(
                          color: (isFollowing ? Colors.orange : Colors.green)
                              .withOpacity(0.3),
                          blurRadius: 8.r, // Responsive blur radius
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFollowing ? Icons.person_remove : Icons.person_add,
                          color: Colors.white,
                          size: 32.sp, // Responsive icon size
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          isFollowing ? "Unfollow" : "Follow",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      );
    },
  );
}
