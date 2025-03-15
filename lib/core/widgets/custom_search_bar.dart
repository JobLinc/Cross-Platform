import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  final String text;

  const CustomSearchBar({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.black87),
          filled: true,
          fillColor: Colors.white70,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none),
        ),
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }
}
