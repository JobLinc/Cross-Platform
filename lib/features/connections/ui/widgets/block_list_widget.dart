import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';

class BlockListView extends StatelessWidget {
  final List<UserConnection> connections;
  final bool isuser;

  BlockListView({Key? key, required this.connections, this.isuser = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: connections.length,
      itemBuilder: (context, index) {
        final connection = connections[index];

        return InkWell(
          key: Key("block_profile_button"),
          onTap: () async {
            print("go to ${connection.firstname} profile");
            final shouldRefresh = await Navigator.pushNamed(
                  context,
                  Routes.otherProfileScreen,
                  arguments: connection.userId,
                ) ??
                false;

            if (shouldRefresh == true) {
              context.read<ConnectionsCubit>().fetchConnections();
            }
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileImage(
                  imageURL: connection.profilePicture,
                  radius: 25.r,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${connection.firstname} ${connection.lastname}",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (connection.headline.isNotEmpty)
                        Text(
                          connection.headline,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (isuser)
                  IconButton(
                    key: Key("connection_unblock_button"),
                    onPressed: () {
                      print("Unblock ${connection.firstname}");
                      showDialog(
                        context: context,
                        builder: (innerContext) => AlertDialog(
                          title: Text('Unblock Connection'),
                          content: Text(
                              'Are you sure you want to unblock ${connection.firstname}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(innerContext),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<ConnectionsCubit>()
                                    .unblockConnection(
                                      connection.userId,
                                      context,
                                    );
                                Navigator.pop(innerContext);
                              },
                              child: Text('Unblock'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.lock_open, size: 20.sp),
                  ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        thickness: 1,
        height: 0,
      ),
    );
  }
}
