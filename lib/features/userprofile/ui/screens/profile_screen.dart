import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companyPages/ui/widgets/company_more.dart';
import 'package:joblinc/features/userprofile/data/user.dart';


class ProfileScreen extends StatelessWidget {
  final User user;

  ProfileScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Cover Photo and Profile Picture
          Container(
            height: 90.h,
            child: Stack(
              children: [
                // Cover Photo
                Image.network(
                  user.coverPicture ??
                      "https://thingscareerrelated.com/wp-content/uploads/2021/10/default-background-image.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 60.h,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 40.h,
                    color: Colors.grey[300], // Fallback color
                  ),
                ),
                // Profile Picture (Circle Avatar)
                Positioned(
                  top: 20.h,
                  left: 17.w,
                  child: CircleAvatar(
                    radius: 30.h,
                    backgroundImage: NetworkImage(
                      user.profilePicture ??
                          'https://www.w3schools.com/howto/img_avatar.png',
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
      
          // User Name & Headline
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "${user.firstName} ${user.lastName}",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    user.headline,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      
          // Connections Count (Pressable)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: GestureDetector(
              onTap: () {
                // Handle tap (e.g., navigate to connections list)
              },
              child: Text(
                "${user.connections} connections",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
      
          // About Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
            child: Text(
              user.about ?? "No about information available.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
          ),
      
          // Action Buttons (Follow, Message, More)
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle follow action
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Text(
                      "+ Follow",
                      style: TextStyle(color: Colors.blue, fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    // Handle message action
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Message",
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CompanyMoreButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
