import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/sent_connections_cubit.dart';

class SentConnectionsList extends StatelessWidget {
  final List<UserConnection> sentInvitations;
  const SentConnectionsList({
    Key? key,
    required this.sentInvitations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: sentInvitations.length,
      itemBuilder: (context, index) {
        final sent = sentInvitations[index];

        return Column(
          children: [
            Container(
              color: ColorsManager.warmWhite, // White background
              child: GestureDetector(
                key: Key("Sent Invitations Page Tile"),
                onTap: () async {
                  // TODO: Navigate to the user's profile
                  print("Go to ${sent.firstname}'s profile");

                  final shouldRefresh = await Navigator.pushNamed(
                          context, Routes.otherProfileScreen,
                          arguments: sent.userId) ??
                      false;

                  if (shouldRefresh == true) {
                    context
                        .read<SentConnectionsCubit>()
                        .fetchSentInvitations(); // or whatever function to refresh
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
                            imageURL: sent.profilePicture,
                            radius: 25.r,
                          )),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text left
                        children: [
                          Text(
                            "${sent.firstname} ${sent.lastname}",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            sent.headline,
                            style: TextStyle(
                                fontSize: 18.sp, color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${sent.mutualConnections} mutual connections",
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ElevatedButton(
                        key: Key("sent_invitations_list_withdraw_button"),
                        onPressed: () {
                          // BlocProvider.of<SentConnectionsCubit>(context)
                          //     .withdrawclicked(sent.userId);
                          context
                              .read<SentConnectionsCubit>()
                              .removeConnection(sent, context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(50), // Circular border
                            side: BorderSide(
                              color: Colors.black, // Border color
                              width: 0.5,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h), // Button padding
                          backgroundColor: Colors.white, // White background
                          foregroundColor: Colors.black, // Black text
                        ),
                        child: Text(
                          "Withdraw",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
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
