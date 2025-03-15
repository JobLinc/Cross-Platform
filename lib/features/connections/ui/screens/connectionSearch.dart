import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/data/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionsListWidget.dart';
import 'package:joblinc/features/connections/ui/widgets/filterButtons.dart';

class Connectionsearch extends StatelessWidget {
  const Connectionsearch({super.key});

  @override
  Widget build(BuildContext context) {
    print("Building ConnectionList");
    //final List<Map<String, String>> connections = BlocProvider.of<TrialCubit>(context).connections;
    final List<Map<String, String>> connections = GetConnections();
    return ScreenUtilInit(
      designSize: Size(412, 924),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Default back arrow
              onPressed: () {
                BlocProvider.of<ConnectionsCubit>(context).Backclicked();
              },
            ),
            title: Expanded(
              child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(), // Optional: Adds a border
                  filled: true,
                  fillColor: Colors.lightBlue[50],
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: SingleChildScrollFilter(),
              ),
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
