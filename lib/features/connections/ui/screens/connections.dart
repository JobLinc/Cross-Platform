import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/screens/InvitationPage.dart';
import 'package:joblinc/features/connections/ui/screens/connectionList.dart';
import 'package:joblinc/features/connections/ui/screens/connectionSearch.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionsCubit, ConnectionsState>(
        builder: (context, state) {
      if (state is ConnectionsInitial) {
        BlocProvider.of<ConnectionsCubit>(context).fetchConnections();
        return Scaffold(
          appBar: AppBar(
            title: Text("Connection", style: TextStyle(fontSize: 20.sp)),
            centerTitle: true,
          ),
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  ColorsManager.darkBurgundy), // Change color here
            ),
          ),
        );
      } else if (state is ConnectionsError) {
        return Scaffold(
          body: Center(
            child: Text(state.error),
          ),
        );
      } else if (state is ConnectionsLoaded) {
        return ConnectionList(
          key: Key("the connection page"),
          connections: state.Connections,
        );
      } else {
        return Container();
      }

      // return InvitationPage(
      //   key: Key("the invitations page"),
      // );
    });
  }
}
