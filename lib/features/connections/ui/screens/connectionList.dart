import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/data/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionHeaderButtons.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionsListWidget.dart';

class ConnectionList extends StatelessWidget {
  @override
  List<Map<String, String>> connections = GetConnections();
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 924),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Connection", style: TextStyle(fontSize: 20.sp)),
            centerTitle: true,
          ),
          body: BlocSelector<ConnectionsCubit, ConnectionsState, SortData>(
            selector: (state) {
              return SortData();
            },
            builder: (context, state) {
              return Column(
                children: [
                  connection_Buttons(
                      connections: BlocProvider.of<ConnectionsCubit>(context)
                          .SortingData()),
                  Divider(
                    color: Colors.grey[300], // Line color
                    thickness: 1, // Line thickness
                    height: 0, // No extra spacing
                  ),
                  Expanded(
                      child: connections_List_View(
                          connections:
                              BlocProvider.of<ConnectionsCubit>(context)
                                  .SortingData())),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
