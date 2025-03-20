import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';

class connections_List_View extends StatelessWidget {
  List<UserConnection> connections;
  connections_List_View({
    Key? key,
    required this.connections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: connections.length,
      itemBuilder: (context, index) {
        final connection = connections[index];

        return Column(
          children: [
            Container(
              color: Colors.white,
              child: GestureDetector(
                key: Key("connection_profile_button"),
                onTap: () {
                  //todo:go to the profile of the user
                  print("go to ${connection.firstname} profile");
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment:
                            Alignment.topLeft, 
                        child: CircleAvatar(
                          radius: 25.r,
                          child: Text(connection.firstname[
                              0]), 
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the left

                        children: [
                          Text(
                            "${connection.firstname} ${connection.lastname}",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            connection.headline,
                            style: TextStyle(
                                fontSize: 18.sp, color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // BlocProvider.of<ConnectionsCubit>(context)
                          //         .connectedOnappear
                          //     ? Text(
                          //         "Connected on ${connection['connected_on']!}",
                          //         style: TextStyle(
                          //             fontSize: 18.sp, color: Colors.grey[600]),
                          //       )
                          //     : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    IconButton(
                        key: Key("connection_chat_button"),
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.chatScreen);
                        },
                        icon: Icon(Icons.send, size: 20.sp)),
                    IconButton(
                        key: Key("connection_more_button"),
                        onPressed: () {
                          //todo : the
                          print("hello ${connection.firstname} more");
                        },
                        icon: Icon(Icons.more_horiz, size: 20.sp)),
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
