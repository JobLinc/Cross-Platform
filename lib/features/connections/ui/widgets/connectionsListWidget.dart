import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';

// ignore: must_be_immutable
class ConnectionsListView extends StatelessWidget {
  List<UserConnection> connections;
  bool isuser;
  ConnectionsListView({Key? key, required this.connections, this.isuser = true})
      : super(key: key);

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
              child: InkWell(
                key: Key("connection_profile_button"),
                onTap: () async {
                  //todo: go to the profile of the user
                  print("go to ${connection.firstname} profile");
                  final shouldRefresh = await Navigator.pushNamed(
                        context,
                        Routes.otherProfileScreen,
                        arguments: connection.userId,
                      ) ??
                      false;

                  if (shouldRefresh == true) {
                    if (isuser) {
                      context.read<ConnectionsCubit>().fetchConnections();
                    } else {
                      // No action for non-user yet
                    }
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
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          connection.headline != ""
                              ? Text(
                                  connection.headline,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : SizedBox.shrink(),
                          connection.time_of_connections != null
                              ? Text(
                                  "Connected on: ${DateFormat.yMMMd().format(connection.time_of_connections!)}",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    isuser
                        ? IconButton(
                            key: Key("connection_chat_button"),
                            onPressed: () async {
                              final chatId = await (context
                                  .read<ConnectionsCubit>()
                                  .createchat(connection.userId));
                              Navigator.pushNamed(context, Routes.chatScreen,
                                  arguments: chatId!);
                            },
                            icon: Icon(Icons.send, size: 20.sp),
                          )
                        : SizedBox.shrink(),
                    isuser
                        ? IconButton(
                            key: Key("connection_more_button"),
                            onPressed: () {
                              print("hello ${connection.firstname} more");
                              showModalBottomSheet(
                                context: context,
                                builder: (innerContext) {
                                  return Padding(
                                    padding: EdgeInsets.all(16.0.sp),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(innerContext);
                                      },
                                      child: Builder(
                                        builder: (innerContext) {
                                          return ListTile(
                                            leading: Icon(
                                              Icons.person_remove,
                                              color: ColorsManager.darkBurgundy,
                                            ),
                                            title: Text("Remove connection"),
                                            onTap: () {
                                              context
                                                  .read<ConnectionsCubit>()
                                                  .removeConnection(
                                                    connection,
                                                    context,
                                                  );
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.more_horiz, size: 20.sp),
                          )
                        : SizedBox.shrink(),
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
