import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';

class InvitationsList extends StatelessWidget {
  final List<Map<String, dynamic>> invitations = [
    {
      "name": "Ahmed Walaa",
      "title": "Mechatronics Engineer",
      "mutualConnections": 30,
      "timeAgo": "1 week ago",
      "avatar": Icons.person,
    },
    {
      "name": "Mazen Ahmed",
      "title": "Communication and Computing",
      "mutualConnections": 58,
      "timeAgo": "1 week ago",
      "avatar": Icons.work,
    },
    {
      "name": "Paula Isaac",
      "title": "Sophomore - Electrical Engineer",
      "mutualConnections": 78,
      "timeAgo": "1 week ago",
      "avatar": Icons.school,
    },
    {
      "name": "Sara Ahmed",
      "title": "Engineering Student",
      "mutualConnections": 56,
      "timeAgo": "1 month ago",
      "avatar": Icons.account_circle,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: invitations.length,
      itemBuilder: (context, index) {
        final invitation = invitations[index];

        return Column(
          children: [
            Container(
              color: ColorsManager.warmWhite, // White background
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to the user's profile
                  print("Go to ${invitation['name']}'s profile");
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment:
                            Alignment.topLeft, // Align avatar to top-left
                        child: CircleAvatar(
                          radius: 25.r, // Bigger avatar
                          child: Text(invitation['name']![0]), // First letter
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text left
                        children: [
                          Text(
                            invitation['name']!,
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            invitation['title']!,
                            style: TextStyle(
                                fontSize: 18.sp, color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${invitation['mutualConnections']} mutual connections",
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.grey[500]),
                          ),
                          Text(
                            invitation['timeAgo'],
                            style: TextStyle(
                                fontSize: 14.sp, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Icon(Icons.close,
                          size: 22.sp, color: Colors.black), // Add const
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Icon(Icons.check_outlined,
                              size: 22.sp,
                              color:
                                  ColorsManager.softDarkBurgundy), // Add const
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
                          )),
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
