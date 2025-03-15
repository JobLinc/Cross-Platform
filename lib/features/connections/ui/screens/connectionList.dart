import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionHeaderButtons.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionsList.dart';

class ConnectionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Building ConnectionList");
    final List<Map<String, String>> connections =
        BlocProvider.of<ConnectionsCubit>(context).connections;

    return ScreenUtilInit(
      designSize: Size(412, 924),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text("Connection", style: TextStyle(fontSize: 20.sp)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Custom back icon
              onPressed: () {
                // Custom function when back button is pressed
                Navigator.pop(context);
                print("Back button pressed!"); // Example action
              },
            ),
          ),
          body: Column(
            children: [
              connection_Buttons(connections: connections),
              Divider(
                color: Colors.grey[300], // Line color
                thickness: 1, // Line thickness
                height: 0, // No extra spacing
              ),
              Expanded(
                  child: connections_List_View(
                connections: connections,
              )),
            ],
          ),
        );
      },
    );
  }
}
