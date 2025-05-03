import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/companypages/ui/widgets/company_more.dart';
import 'package:joblinc/features/companypages/ui/widgets/follow_button.dart';
import 'package:joblinc/features/companypages/ui/widgets/visit_company_website.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'square_avatar.dart';
import '../../data/data/company.dart';

class CompanyData extends StatelessWidget {
  final Company company;
  final bool isAdmin;

  CompanyData({required this.company, this.isAdmin = false, super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is an admin
    if (isAdmin) {
      final authService = getIt<AuthService>();
      authService.refreshToken(companyId: company.id);
    }
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
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 60.h,
                      color: Colors.grey[300],
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
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
                GestureDetector(
                  onTap: () async {
                    // Refresh token before navigating (if needed)
                    // await AuthService().refreshToken(companyId: company.id); // <-- Call here if you want to refresh before navigation
                    final refresh = await Navigator.pushNamed(
                        context, Routes.companyPicturesManage, arguments: {
                      'image': company,
                      'iscover': true,
                      'isadmin': true
                    });
                    if (refresh == true) {
                      // Handle refresh logic if needed
                    }
                  },
                  child: Image.network(
                    company.coverUrl ??
                        "https://thingscareerrelated.com/wp-content/uploads/2021/10/default-background-image.png", // Default image if null
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 60.h,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 60.h,
                        color: Colors.grey[300],
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 40.h,
                      color: Colors.grey[300], // Fallback color
                    ),
                  ),
                ),
                Positioned(
                  top: 20.h,
                  left: 17.w,
                  child: GestureDetector(
                    onTap: () async {
                      // Refresh token before navigating (if needed)
                      // await AuthService().refreshToken(companyId: company.id); // <-- Call here if you want to refresh before navigation
                      final refresh = await Navigator.pushNamed(
                          context, Routes.companyPicturesManage, arguments: {
                        'image': company,
                        'iscover': false,
                        'isadmin': true
                      });
                      if (refresh == true) {}
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.industry,
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.grey.shade600),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text(
                                company.followers.toString() + " followers",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey.shade600),
                              ),
                              SizedBox(width: 10.w),
                              Icon(Icons.circle,
                                  size: 6.sp, color: Colors.grey.shade600),
                              SizedBox(width: 10.w),
                              Text(
                                company.organizationSize,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                    if (company.isFollowing == false )
                      FollowButton(
                          text: "+ Follow",
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFFD72638),
                          borderColor: Color(0xFFD72638),
                          width: company.website != null && company.website!.isNotEmpty
                              ? 130.w
                              : 280.w,
                          fontSize: 13.sp,
                          onTap: () async {
                            company.followers++;
                            print("Follow button pressed");
                            try {
                              final UserConnectionsRepository
                                  userConnectionsRepository =
                                  getIt<UserConnectionsRepository>();
                              final result = await userConnectionsRepository
                                  .follwConnection(company.id!);
                              company.isFollowing = true;

                              if (result.statusCode == 200) {
                                Navigator.pushReplacementNamed(
                                    context, Routes.companyPageHome,
                                    arguments: {
                                      'company': company,
                                      'isAdmin': isAdmin
                                    });
                                CustomSnackBar.show(
                                  context: context,
                                  message:
                                      "You are now following ${company.name}",
                                  type: SnackBarType.success,
                                );
                              }
                            } catch (e) {
                              CustomSnackBar.show(
                                context: context,
                                message: "Failed to follow ${company.name}",
                                type: SnackBarType.error,
                              );
                            }
                          }),
                    if (company.isFollowing == true || isAdmin)
                      FollowButton(
                          text: "- Unfollow",
                          backgroundColor: Color(0xFFD72638),
                          foregroundColor: Colors.white,
                          borderColor: Color(0xFFD72638),
                          width: company.website != null && company.website!.isNotEmpty
                              ? 130.w
                              : 280.w,
                          fontSize: 13.sp,
                          onTap: () async {
                            if (isAdmin) {
                              CustomSnackBar.show(
                                context: context,
                                message: "You can't unfollow your own company",
                                type: SnackBarType.error,
                              );
                              return;
                            }
                            print("Unfollow button pressed");
                            try {
                            final UserConnectionsRepository
                                userConnectionsRepository =
                                getIt<UserConnectionsRepository>();
                            final result = await userConnectionsRepository
                                .unfollwConnection(company.id!);

                            if (company.followers > 0) {
                              company.followers--;
                            }
                            company.isFollowing = false;
                            if (result.statusCode == 200) {
                              CustomSnackBar.show(
                                context: context,
                                message: "You unfollowed ${company.name}",
                                type: SnackBarType.success,
                              );
                            }
                            } catch(e) {
                              CustomSnackBar.show(
                                context: context,
                                message: "Failed to follow ${company.name}",
                                type: SnackBarType.error,
                              );
                            }
                            Navigator.pushReplacementNamed(
                                context, Routes.companyPageHome, arguments: {
                              'company': company,
                              'isAdmin': isAdmin
                            });
                          }),
                    if (company.website != null && company.website!.isNotEmpty)
                      SizedBox(width: 12.w),
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
