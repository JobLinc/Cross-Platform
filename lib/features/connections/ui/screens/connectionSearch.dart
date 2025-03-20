import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionsListWidget.dart';
import 'package:joblinc/features/connections/ui/widgets/filterButtons.dart';

class Connectionsearch extends StatelessWidget {
  const Connectionsearch({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 924),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            leading: IconButton(
              key: Key('connectionsearch_back_button'),
              icon: Icon(Icons.arrow_back), // Default back arrow
              onPressed: () {
                BlocProvider.of<ConnectionsCubit>(context).Backclicked();
              },
            ),
            title: CustomSearchBar(key: Key("Search bar "), text: 'Search'),
          ),
          body: Column(
            key: Key("search Page body"),
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: SingleChildScrollFilter(key: Key("Search bage filters"),),
              ),
              Divider(
                color: Colors.grey[300], // Line color
                thickness: 1, // Line thickness
                height: 0, // No extra spacing
              ),
              Expanded(
                  child: connections_List_View(key: Key("Search page connections List"),
                connections:
                    BlocProvider.of<ConnectionsCubit>(context).connections,
              )),
            ],
          ),
        );
      },
    );
  }
}
