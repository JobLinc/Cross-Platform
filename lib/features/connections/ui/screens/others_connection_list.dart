import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionHeaderButtons.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionsListWidget.dart';

// ignore: must_be_immutable
class OthersConnectionList extends StatelessWidget {
  late List<UserConnection> connections;
  OthersConnectionList({
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
                  if (state is ConnectionsLoaded) {
                    connections = state.Connections;
                    return Column(
                      key: Key("ConnectionListbody"),
                      children: [
                        connection_Buttons(connections: connections),
                        Expanded(
                            child: ConnectionsListView(
                          key: Key("the List of connections"),
                          connections: connections,
                          isuser: false,
                        )),
                      ],
                    );
                  } else if (state is ConnectionsError) {
                    return Text(state.error);
                  } else if (state is ConnectionsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }));
      },
    );
  }
}
