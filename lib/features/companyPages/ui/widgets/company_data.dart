import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/companypages/logic/cubit/edit_company_cubit.dart';
import 'package:joblinc/features/companypages/ui/widgets/company_more.dart';
import 'package:joblinc/features/companypages/ui/widgets/follow_button.dart';
import 'package:joblinc/features/companypages/ui/widgets/visit_company_website.dart';
import 'package:joblinc/features/userprofile/data/service/file_pick_service.dart';
import 'square_avatar.dart';
import '../../data/data/company.dart';

class CompanyData extends StatelessWidget {
  final Company company;
  final bool isAdmin;

  CompanyData({required this.company, this.isAdmin = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show profile picture and cover photo only if not admin
        if (!isAdmin)
          Container(
            height: 90.h,
            child: Stack(
              children: [
                Image.network(
                  company.coverUrl ??
                      "https://thingscareerrelated.com/wp-content/uploads/2021/10/default-background-image.png", // Default image if null
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 60.h,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 40.h,
                    color: Colors.grey[300], // Fallback color
                  ),
                ),
                Positioned(
                  top: 20.h,
                  left: 17.w,
                  child: SquareAvatar(
                    imageUrl: company.logoUrl ??
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfphRB8Syzj7jIYXedFOeVZwicec0QaUv2cBwPc0l7NnXdjBKpoL9nDSeX46Tich1Razk&usqp=CAU', // Default logo if null
                    size: 60.h,
                  ),
                ),
              ],
            ),
          ),
        if (isAdmin)
          Container(
            height: 90.h,
            child: Stack(
              children: [
                Image.network(
                  company.coverUrl ??
                      "https://thingscareerrelated.com/wp-content/uploads/2021/10/default-background-image.png", // Default image if null
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 60.h,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 40.h,
                    color: Colors.grey[300], // Fallback color
                  ),
                ),
                Positioned(
                  top: 20.h,
                  left: 17.w,
                  child: GestureDetector(
                    onTap: () async {
                      final refresh = await Navigator.pushNamed(
                          context, Routes.companyPicturesManage, arguments: {
                        'image': company,
                        'iscover': false,
                        'isadmin': isAdmin
                      });
                      if (refresh == true) 
                      {
                      }
                      //   showModalBottomSheet(
                      //     context: context,
                      //     builder: (bottomSheetContext) => Container(
                      //       padding: EdgeInsets.all(16),
                      //       child: Column(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           ListTile(
                      //             leading: Icon(Icons.camera_alt),
                      //             title: Text("Take a photo"),
                      //             onTap: () async {
                      //               File? image = await pickImage("camera");
                      //               // Do something when Tile 1 is tapped
                      //               print("Tile 1 tapped");
                      //               if (image == null) {
                      //                 return;
                      //               }
                      //               context
                      //                   .read<EditCompanyCubit>()
                      //                   .uploadCompanyLogo(image);
                      //               Navigator.pop(
                      //                   bottomSheetContext); // Close the bottom sheet
                      //             },
                      //           ),
                      //           ListTile(
                      //             leading: Icon(Icons.photo_library),
                      //             title: Text("Upload from photos"),
                      //             onTap: () async {
                      //               File? image = await pickImage("gallery");
                      //               // Do something when Tile 2 is tapped
                      //               print("Tile 2 tapped");
                      //               if (image == null) {
                      //                 print("I am in this");
                      //                 return;
                      //               }
                      //               Navigator.pop(bottomSheetContext);
                      //               context
                      //                   .read<EditCompanyCubit>()
                      //                   .uploadCompanyLogo(image);
                      //               // Response response = await getIt<UserProfileRepository>()
                      //               //     .uploadProfilePicture(image!);
                      //               // print(response.statusCode);
                      //               // Close the bottom sheet
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   );
                    },
                    child: SquareAvatar(
                      imageUrl: company.logoUrl ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfphRB8Syzj7jIYXedFOeVZwicec0QaUv2cBwPc0l7NnXdjBKpoL9nDSeX46Tich1Razk&usqp=CAU', // Default logo if null
                      size: 60.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Column containing the rest of the UI elements
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Name and Verification
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Text(
                      company.name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (company.isVerified)
                      Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Icon(Icons.verified_user_outlined),
                      ),
                  ],
                ),
              ),

              // Company Details (Industry, Location, Followers, Size)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.0.w,
                  runSpacing: 4.0.h,
                  children: [
                    Text(
                      company.industry.displayName,
                      style: TextStyle(
                          fontSize: 16.sp, color: Colors.grey.shade600),
                    ),
                    Icon(Icons.circle, size: 6.sp, color: Colors.grey.shade600),
                    Text(
                      company.location ?? "Location not available",
                      style: TextStyle(
                          fontSize: 16.sp, color: Colors.grey.shade600),
                    ),
                    Icon(Icons.circle, size: 6.sp, color: Colors.grey.shade600),
                    Text(
                      company.followers
                          .toString(), // TODO: Replace with actual followers
                      style: TextStyle(
                          fontSize: 16.sp, color: Colors.grey.shade600),
                    ),
                    Icon(Icons.circle, size: 6.sp, color: Colors.grey.shade600),
                    Text(
                      company.organizationSize.displayName,
                      style: TextStyle(
                          fontSize: 16.sp, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              // Action Buttons (Visit Website, Follow, More)
              Padding(
                padding: EdgeInsets.only(top: 12.h, left: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (company.website != null && company.website!.isNotEmpty)
                      VisitCompanyWebsite(
                        text: 'Visit Website',
                        backgroundColor: Color(0xFFD72638),
                        borderColor: Color(0xFFD72638),
                        foregroundColor: Colors.white,
                        icon: Icons.open_in_new,
                        websiteUrl: company.website!,
                        width: 150.w,
                        fontSize: 11.sp,
                      ),
                    SizedBox(width: 10.w),
                    FollowButton(
                      text: "+ Follow",
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFFD72638),
                      borderColor: Color(0xFFD72638),
                      width: 130.w,
                      fontSize: 13.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.h),
                      child: CompanyMoreButton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
