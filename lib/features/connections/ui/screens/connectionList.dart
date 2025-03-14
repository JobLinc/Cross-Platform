import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/data/connectiondemoModel.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionHeaderButtons.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionsList.dart';

class ConnectionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final List<Map<String, String>> connections = BlocProvider.of<TrialCubit>(context).connections;
    final List<Map<String, String>> connections = GetConnections();
    return ScreenUtilInit(
      designSize: Size(412, 924),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              title: Text("Connection", style: TextStyle(fontSize: 20.sp)),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back), // Custom back icon
                onPressed: () {
                  // Custom function when back button is pressed

                  print("Back button pressed!"); // Example action
                },
              ),
            ),
            body: Column(
              children: [
                connection_Buttons(connections, context),
                Divider(
                  color: Colors.grey[300], // Line color
                  thickness: 1, // Line thickness
                  height: 0, // No extra spacing
                ),
                Expanded(child: connections_List_View(connections)),
              ],
            ),
          ),
        );
      },
    );
  }
}
