// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';

import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

class otherProfileCoverImages extends StatelessWidget {
  final UserProfile profile;
  const otherProfileCoverImages({
    Key? key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover image
        Column(
          children: [
            GestureDetector(
              onTap: () {
                // Add action here when tapped
                print('Cover picture tapped');
                Navigator.pushNamed(context, Routes.otherImagesPreview,
                    arguments: profile.coverPicture);
              },
              child: Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Soft color for the background
                  image: profile.coverPicture.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage("${profile.coverPicture}"),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profile.coverPicture.isNotEmpty
                    ? Image.network(
                        "${profile.coverPicture}",
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                          );
                        },
                      )
                    : null,
              ),
            ),
            Container(
              height: 50.h,
              width: double.infinity,
            ),
          ],
        ),

        // Profile image with edit button
        Positioned(
          left: 20.w,
          top: 100.h,
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
              Navigator.pushNamed(context, Routes.otherImagesPreview,
                  arguments: profile.profilePicture);
              print("profile Picture tapped");
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
                                "${profile.profilePicture}",
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
}
