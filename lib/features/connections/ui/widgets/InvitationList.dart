// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/invitations_cubit.dart';

class InvitationsList extends StatelessWidget {
  final List<UserConnection> invitations;
  const InvitationsList({
    Key? key,
    required this.invitations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      //reverse: true,
      itemCount: invitations.length,
      itemBuilder: (context, index) {
        final invitation = invitations[index];

        return Column(
          children: [
            Container(
              color: ColorsManager.warmWhite, // White background
              child: GestureDetector(
                key: Key("Invitations page Tile"),
                onTap: () async {
                  // TODO: Navigate to the user's profile
                  //print("Go to ${invitation.firstname}'s profile");
                  final shouldRefresh = await Navigator.pushNamed(
                        context,
                        Routes.otherProfileScreen,
                        arguments: invitation.userId,
                      ) ??
                      false;

                  if (shouldRefresh == true) {
                    context
                        .read<InvitationsCubit>()
                        .fetchPendingInvitations(); // or whatever function to refresh
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Align(
                          alignment:
                              Alignment.topLeft, // Align avatar to top-left
                          child: ProfileImage(
                            imageURL: invitation.profilePicture,
                            radius: 25.r,
                          )),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text left
                        children: [
                          Text(
                            invitation.firstname,
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            invitation.headline,
                            style: TextStyle(
                                fontSize: 18.sp, color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${invitation.mutualConnections} mutual connections",
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.grey[500]),
                          ),
                          // Text(
                          //   invitation.,
                          //   style: TextStyle(
                          //       fontSize: 14.sp, color: Colors.grey[500]),
                          // ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      key: Key("invitationslist_delete_button"),
                      onPressed: () {
                        // BlocProvider.of<InvitationsCubit>(context)
                        //     .handleInvitation(invitation, "Denied");
                        context
                            .read<InvitationsCubit>()
                            .respondToConnectionInvitation(
                                invitation, "Rejected", context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(
                          side: BorderSide(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        fixedSize: Size(10.w, 10.h),
                      ),
                      child: Icon(Icons.close,
                          size: 22.sp, color: Colors.black), // Add const
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ElevatedButton(
                        key: Key("invitationslist_accept_button"),
                        onPressed: () {
                          // BlocProvider.of<InvitationsCubit>(context)
                          //     .handleInvitation(invitation, "Accepted");
                          context
                              .read<InvitationsCubit>()
                              .respondToConnectionInvitation(
                                  invitation, "Accepted", context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(
                            side: BorderSide(
                              color: ColorsManager.softDarkBurgundy,
                              width: 0.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(5),
                          backgroundColor: Colors.white,
                          foregroundColor: ColorsManager.softDarkBurgundy,
                          fixedSize: Size(10.w, 10.h),
                        ),
                        child: Icon(Icons.check_outlined,
                            size: 22.sp,
                            color: ColorsManager.softDarkBurgundy), // Add const
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300], // Line color
        thickness: 1, // Line thickness
        height: 0, // No extra spacing
      ),
    );
  }
}
