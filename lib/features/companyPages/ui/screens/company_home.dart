import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          home: CompanyPageHome(),
        );
      },
    );
  }
}

class CompanyPageHome extends StatelessWidget {
  const CompanyPageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Microsoft', // Company Name goes here
                overflow: TextOverflow.ellipsis, // Add ellipsis if the text is too long
              ),
            ),
            CustomSearchBar(
              text: 'Microsoft', // Company Name goes here
              onPress: () {},
              onTextChange: (searched) {},
              controller: TextEditingController(),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final String text;
  final Function onPress;
  final Function onTextChange;
  final TextEditingController controller;

  CustomSearchBar({
    required this.text,
    required this.onPress,
    required this.onTextChange,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          controller: controller,
          onTap: () => onPress(),
          onChanged: (searched) => onTextChange(searched),
          decoration: InputDecoration(
            hintText: text,
            prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.black87),
            filled: true,
            fillColor: Colors.white70,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }
}