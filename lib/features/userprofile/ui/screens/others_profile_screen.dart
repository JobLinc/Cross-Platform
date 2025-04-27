import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userprofile/ui/widgets/others_connections.dart';
import 'package:joblinc/features/userprofile/ui/widgets/others_images.dart';
import 'package:joblinc/features/userprofile/ui/widgets/others_more_actions.dart';
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: Icon(Icons.arrow_back)),
      ),
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
                                onPressed: _getActionBasedOnConnectionStatus(
                                    profile.connectionStatus,
                                    context,
                                    context.read<ProfileCubit>(),
                                    profile.userId),
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
                              onPressed: () {
                                showModalBasedOnConnectionStatus(
                                    context,
                                    profile.connectionStatus,
                                    context.read<ProfileCubit>(),
                                    profile.userId);
                              },
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
                              child: const Icon(Icons.more_horiz_outlined,
                                  color: Colors.black),
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
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

String _getMessageBasedOnConnectionStatus(String connectionStatus) {
  switch (connectionStatus) {
    case 'Accepted':
      return 'Message';
    case 'Received':
      return 'Respond';
    case 'Sent':
      return 'Pending Request';
    case 'Blocked':
      return 'Blocked';
    case 'Not Connected':
      return 'Connect Now';
    default:
      return 'Nothing to see'; // Default case if none of the above matches
  }
}

VoidCallback? _getActionBasedOnConnectionStatus(String connectionStatus,
    BuildContext context, ProfileCubit cubit, String userId) {
  switch (connectionStatus) {
    case 'Connected':
      return () {
        // Navigate to Chat or send message
      };
    case 'Received':
      return () {
        _respondToRequest(context, cubit, userId);
      };
    case 'Sent':
      return () {
        withdrawConnection(context, cubit, userId);
      }; // No action for pending request
    case 'Blocked':
      return null; // No action for blocked
    case 'Not Connected':
      return () {
        cubit.sendConnectionRequest(userId, context);
      };
    default:
      return null;
  }
}

// Function to respond to a connection request (Accept/Reject)
void _respondToRequest(
    BuildContext context, ProfileCubit cubit, String userId) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r)), // Responsive border radius
    ),
    backgroundColor: Colors.white,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 24.w, vertical: 32.h), // Responsive padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.handshake,
                size: 48.sp, color: Colors.blue), // Responsive icon size
            SizedBox(height: 16.h),
            Text(
              "Respond to Connection Request",
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
                // Accept Button
                GestureDetector(
                  onTap: () {
                    cubit.respondToConnectionInvitation(
                        userId, "Accepted", context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 120.w, // Responsive width
                    padding: EdgeInsets.symmetric(
                        vertical: 14.h), // Responsive padding
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade700,
                      borderRadius:
                          BorderRadius.circular(16.r), // Responsive radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8.r, // Responsive blur radius
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.white,
                            size: 32.sp), // Responsive icon size
                        SizedBox(height: 8.h),
                        Text(
                          "Accept",
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
                // Reject Button
                GestureDetector(
                  onTap: () {
                    cubit.respondToConnectionInvitation(
                        userId, "Rejected", context);
                    Navigator.pop(context);
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
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cancel,
                            color: Colors.white,
                            size: 32.sp), // Responsive icon size
                        SizedBox(height: 8.h),
                        Text(
                          "Reject",
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

// Function to withdraw a connection
void withdrawConnection(
    BuildContext context, ProfileCubit cubit, String userId) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.white,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 24.w, vertical: 32.h), // Responsive padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.undo,
                size: 48.sp,
                color: Colors.orangeAccent), // Responsive icon size
            const SizedBox(height: 16),
            const Text(
              "Withdraw Connection",
              style: TextStyle(
                fontSize: 22, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                cubit.removeConnection(userId, context);
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(vertical: 16.h), // Responsive padding
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius:
                      BorderRadius.circular(16.r), // Responsive radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 8.r, // Responsive blur radius
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: const [
                    Icon(Icons.undo,
                        color: Colors.white, size: 32), // Responsive icon size
                    SizedBox(height: 8),
                    Text(
                      "Withdraw",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Responsive font size
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
