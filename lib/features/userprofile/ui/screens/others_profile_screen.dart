import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';

import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/ui/widgets/others_connections.dart';
import 'package:joblinc/features/userprofile/ui/widgets/others_images.dart';

class othersProfileScreen extends StatelessWidget {
  final UserProfile profile;
  const othersProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header with cover and profile images
            otherProfileCoverImages(profile: profile),

            // Profile info
            Padding(
              padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${profile.firstname} ${profile.lastname}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      // Alternative edit button
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
                  SizedBox(height: 8.h),
                  othersConnections(profile: profile),
                  SizedBox(height: 8.h),
                  //this row is the buttons row in the user profile home page
                  Row(
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            // Your action here
                            Navigator.pushNamed(context, Routes.chatScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                color:
                                    ColorsManager.darkBurgundy), // White border
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor:
                                Colors.white, // Set your own color here
                          ),
                          child: Center(
                            // This ensures the text is centered
                            child: Text(
                              'Message',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: ColorsManager.darkBurgundy,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Icon(Icons.more_horiz_outlined,
                            color: Colors.black),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(
                            side: BorderSide(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(5),
                          backgroundColor: Color(0xFFFAFAFA),
                          foregroundColor: Colors.black,
                          fixedSize: Size(50.w, 50.h),
                        ),
                      ),
                    ],
                  ),

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
}
