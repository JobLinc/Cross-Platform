import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userprofile/ui/widgets/others_connections.dart';
import 'package:joblinc/features/userprofile/ui/widgets/others_images.dart';
import 'package:joblinc/features/userprofile/ui/widgets/user_cerificates.dart';
import 'package:joblinc/features/userprofile/ui/widgets/user_experiences.dart';
import 'package:joblinc/features/userprofile/ui/widgets/user_skills.dart';

class OthersProfileScreen extends StatefulWidget {
  final String userId;
  const OthersProfileScreen({super.key, required this.userId});

  @override
  State<OthersProfileScreen> createState() => _OthersProfileScreenState();
}

class _OthersProfileScreenState extends State<OthersProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getPublicUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  otherProfileCoverImages(profile: profile),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${profile.firstname} ${profile.lastname}',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        if (profile.headline.isNotEmpty)
                          Text(profile.headline,
                              style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 5.h),
                        Text('${profile.city}, ${profile.country}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 8.h),
                        othersConnections(profile: profile),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigator.pushNamed(
                                  //     context, Routes.chatScreen);
                                },
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      color: ColorsManager.darkBurgundy),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  backgroundColor: Colors.white,
                                ),
                                child: Center(
                                    child: Text(
                                  _getMessageBasedOnConnectionStatus(
                                      profile.connectionStatus),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: ColorsManager.darkBurgundy,
                                  ),
                                )),
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
                                backgroundColor: const Color(0xFFFAFAFA),
                                foregroundColor: Colors.black,
                                fixedSize: Size(50.w, 50.h),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        if (profile.biography.isNotEmpty)
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('About',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                SizedBox(height: 8.h),
                                Text(profile.biography),
                              ],
                            ),
                          ),
                        if (profile.experiences.isNotEmpty) ...[
                          SizedBox(height: 50.h),
                          UserExperiences(
                            profile: profile,
                            isuser: false,
                          )
                        ],

                        // Certificates section
                        if (profile.certifications.isNotEmpty) ...[
                          UserCerificates(
                            profile: profile,
                            isuser: false,
                          ),
                        ],

                        // Skills section
                        if (profile.skills.isNotEmpty) ...[
                          UserSkills(
                            profile: profile,
                            isuser: false,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

String _getMessageBasedOnConnectionStatus(String connectionStatus) {
  switch (connectionStatus) {
    case 'Connected':
      return 'Message';
    case 'Pending':
      return 'Pending Request';
    case 'Blocked':
      return 'Blocked';
    case 'NotConnected':
      return 'Connect Now';
    default:
      return 'Message'; // Default case if none of the above matches
  }
}
