import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';

class ConnectionsListView extends StatelessWidget {
  List<UserConnection> connections;
  ConnectionsListView({
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
                onTap: () async {
                  //todo:go to the profile of the user
                  print("go to ${connection.firstname} profile");
                  final shouldRefresh = await Navigator.pushNamed(
                          context, Routes.otherProfileScreen,
                          arguments: connection.userId) ??
                      false;

                  if (shouldRefresh == true) {
                    context.read<ConnectionsCubit>().fetchConnections();
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ProfileImage(
                          imageURL: connection.profilePicture,
                          radius: 25.r,
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
                          connection.time_of_connections != null
                              ? Text(
                                  "Connected on: ${DateFormat.yMMMd().format(connection.time_of_connections!)}",
                                  style: TextStyle(
                                      fontSize: 18.sp, color: Colors.grey[600]),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : SizedBox.shrink(),
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
                          // Todo : remove the connection

                          // context
                          //     .read<ConnectionsCubit>()
                          //     .removeConnection(connection);

                          showModalBottomSheet(
                            context: context,
                            builder: (innerContext) {
                              return Padding(
                                padding: EdgeInsets.all(16.0.sp),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(innerContext);
                                  },
                                  child: Builder(builder: (innerContext) {
                                    return ListTile(
                                      leading: Icon(Icons.person_remove,
                                          color: ColorsManager.darkBurgundy),
                                      title: Text("Remove connection"),
                                      onTap: () {
                                        context
                                            .read<ConnectionsCubit>()
                                            .removeConnection(
                                                connection, context);
                                        Navigator.pop(context);
                                      },
                                    );
                                  }),
                                ),
                              );
                            },
                          );
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
