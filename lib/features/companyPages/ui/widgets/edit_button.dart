import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35.w,
      height: 40.h,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.elliptical(20, 20),
              bottom: Radius.elliptical(20, 20),
            ),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 1.w,
            ),
            color: Colors.white),
        child: IconButton(
            onPressed: () {}, //TODO : Make it upload a picture when pressed
            icon: Icon(Icons.edit_outlined)),
      ),
    );
  }
}
