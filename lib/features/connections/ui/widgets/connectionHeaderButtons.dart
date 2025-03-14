import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget connection_Buttons(
  List<Map<String, String>> connections,
  BuildContext context,
) {
  return Container(
    color: Colors.white,
    child: Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width / 12),
        Text(
          "${connections.length} Connection",
          style: TextStyle(fontSize: 20.sp),
        ),
        Expanded(child: SizedBox(width: 1.sw)),
        IconButton(
          onPressed: () {
            // Navigator.pushNamed(
            //     context,
            //     Routes.connectionListSearch,
            //     // arguments: connections,
            //   );
            //BlocProvider.of<TrialCubit>(context).Searchclicked();
          },
          icon: Icon(Icons.search),
        ),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context, builder: (context) => /*SortBottomSheet()*/Container());
            },
            icon: Icon(Icons.sort)),
      ],
    ),
  );
}
