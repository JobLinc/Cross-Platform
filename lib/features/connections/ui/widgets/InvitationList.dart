import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              color: Colors.white, // White background
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
                    IconButton(
                      onPressed: () {
                        print("Declined ${invitation['name']}");
                      },
                      icon: Icon(Icons.close, size: 30.sp, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        print("Accepted ${invitation['name']}");
                      },
                      icon: Icon(Icons.check_circle,
                          size: 35.sp, color: Colors.green),
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
