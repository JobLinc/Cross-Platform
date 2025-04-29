import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';

class CustomHorizontalPillBar extends StatefulWidget {
  bool changePillColor;
  String selectedLabel;
  final List<String> items;
  final Function(String) onItemSelected;

  CustomHorizontalPillBar({
    Key? key,
    this.changePillColor=true,
    this.selectedLabel="None",
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<CustomHorizontalPillBar> createState() => _CustomHorizontalPillBarState();


}

class _CustomHorizontalPillBarState extends State<CustomHorizontalPillBar> {
  late String _selectedLabel; // state variable

  @override
  void initState() {
    super.initState();
    _selectedLabel = widget.selectedLabel; // initialize with the default value passed in
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white70,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Row(
              children: widget.items.map((label) {
                bool isSelected = label == _selectedLabel;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLabel = label;
                    });
                    widget.onItemSelected(label);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.r),
                      color: widget.changePillColor ? (isSelected ? ColorsManager.getPrimaryColor(context): Colors.white) : Colors.white,
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: widget.changePillColor ? (isSelected ? Colors.white : Colors.black) : Colors.black ,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}