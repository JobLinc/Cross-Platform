import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/sortSheet.dart';

class connection_Buttons extends StatelessWidget {
  List<Map<String, String>> connections;
  connection_Buttons({super.key, required this.connections});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width / 12),
          Text(
            "${connections.length} Connection",
            style: TextStyle(fontSize: 20.sp),
          ),
          Expanded(child: SizedBox(width: 1.sw)),
          IconButton(
            key: Key("Search button"),
            onPressed: () {
              // Navigator.pushNamed(
              //     context,
              //     Routes.connectionListSearch,
              //     // arguments: connections,
              //   );
              BlocProvider.of<ConnectionsCubit>(context).Searchclicked();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
              key: Key("Sorting button"),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (bcontext) {
                    final cubit = BlocProvider.of<ConnectionsCubit>(
                        context); // Get cubit outside

                    if (!cubit.firstNameSelected &&
                        !cubit.lastNameSelected &&
                        !cubit.recentlyAddedSelected) {
                      cubit.recentlyAddedSelected = true;
                    }

                    return BlocProvider.value(
                      value: cubit, // Pass the existing cubit
                      child: SortBottomSheet(
                        key: Key("bottom sorting sheet "),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.sort)),
        ],
      ),
    );
  }
}
