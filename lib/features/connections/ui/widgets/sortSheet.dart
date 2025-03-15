 import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionsCubit,ConnectionsState>(builder: (context,state)
    {
      return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(child: Text("Sort By", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold))),
          SizedBox(height: 15.h),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 10.w,
            runSpacing: 10.h,
           children: [
              buildSortButton(context: context,label: "Recently added",isSelected : BlocProvider.of<ConnectionsCubit>(context).recentlyAddedSelected),
              buildSortButton(context: context,label: "First name",isSelected: BlocProvider.of<ConnectionsCubit>(context).firstNameSelected),
              buildSortButton(context: context,label : "Last name",isSelected: BlocProvider.of<ConnectionsCubit>(context).lastNameSelected),
            ],),
          SizedBox(height: 20.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              minimumSize:  Size(double.infinity, 50.h),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child:  Text("Show results", style: TextStyle(fontSize: 16.sp, color: Colors.white)),
          ),
        ],
      ),
    );
    }) ;
  }
}
Widget buildSortButton({required BuildContext context,required String label, required bool isSelected }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: ()
      {
        BlocProvider.of<ConnectionsCubit>(context).buttonPressed(label);
      },
      child: Text(label),
    );
  }