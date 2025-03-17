import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  
  final String text;
  //bool? isSearching=false;
  //List<dynamic>? allItems;
  //List<dynamic>? searchedItems;
  final Function onPress;
  final Function onTextChange;
  final TextEditingController controller;

  
  CustomSearchBar({
    required this.text,
    //this.isSearching,
    //this.allItems,
    //this.searchedItems,
    required this.onPress,
    required this.onTextChange,
    required this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          controller: controller,
          onTap: (){ onPress();} ,
          onChanged: (searched){onTextChange(searched);},
          decoration: InputDecoration(
            hintText: text,
            prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.black87),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none),
          ),
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }
}