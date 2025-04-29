// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/block_list_widget.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionHeaderButtons.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionsListWidget.dart';

// ignore: must_be_immutable
class BlockedList extends StatelessWidget {
  late List<UserConnection> connections;

  BlockedList({
    Key? key,
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
              key: Key("Blocked_back_button"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              "Blocked",
              style: TextStyle(fontSize: 20.sp),
            ),
            centerTitle: true,
          ),
          body: BlocConsumer<ConnectionsCubit, ConnectionsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ConnectionsLoaded) {
                connections = state.Connections;
                return Column(
                  key: Key("BlockedListbody"),
                  children: [
                    Expanded(
                      child: BlockListView(
                        key: Key("the List of blocked"),
                        connections: connections,
                        isuser: true,
                      ),
                    ),
                  ],
                );
              } else if (state is ConnectionsError) {
                return Text(state.error);
              } else if (state is ConnectionsInitial) {
                context.read<ConnectionsCubit>().fetchBlockedConnections();
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}
