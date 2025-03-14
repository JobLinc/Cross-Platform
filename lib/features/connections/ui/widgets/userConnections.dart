import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget connections_List_View(List<Map<String, String>> connections) {
  return ListView.separated(
    itemCount: connections.length,
    itemBuilder: (context, index) {
      final connection = connections[index];

      return Column(
        // Wrap GestureDetector inside Column
        children: [
          Container(
            color: Colors.white,
            child: GestureDetector(
              onTap: () {
                //todo:go to the profile of the user
                print("go to ${connection['name']} profile");
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft, // Forces it to the top-left
                      child: CircleAvatar(
                        radius: 25,
                        child: Text(
                            connection['name']![0]), // First letter as avatar
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left

                      children: [
                        Text(
                          connection['name']!,
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          connection['title']!,
                          style: TextStyle(
                              fontSize: 18.sp, color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Connected on ${connection['Last_Connected']!}",
                          style: TextStyle(
                              fontSize: 18.sp, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        //todo : go to chat
                        print("hello ${connection['name']} chat");
                      },
                      icon: Icon(Icons.send)),
                  IconButton(
                      onPressed: () {
                        //todo : the
                        print("hello ${connection['name']} more");
                      },
                      icon: Icon(Icons.more_horiz)),
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
