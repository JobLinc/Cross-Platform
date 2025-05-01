// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';

import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionHeaderButtons.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionsListWidget.dart';

// ignore: must_be_immutable
class ConnectionList extends StatelessWidget {
  List<UserConnection> connections;
  ConnectionList({
    Key? key,
    required this.connections,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 924),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  key: Key("connections_back_button"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  icon: Icon(Icons.arrow_back)),
              title: Text("Connection", style: TextStyle(fontSize: 20.sp)),
              centerTitle: true,
            ),
            body: BlocConsumer<ConnectionsCubit, ConnectionsState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Column(
                    key: Key("ConnectionListbody"),
                    children: [
                      connection_Buttons(
                          key: Key(
                              "number of connections and search and sort buttons"),
                          connections: connections),
                      Divider(
                        color: Colors.grey[300], // Line color
                        thickness: 1, // Line thickness
                        height: 0, // No extra spacing
                      ),
                      Expanded(
                          child: ConnectionsListView(
                              key: Key("the List of connections"),
                              connections: connections)),
                    ],
                  );
                }));
      },
    );
  }
}
