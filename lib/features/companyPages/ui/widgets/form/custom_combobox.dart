import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomEnumDropdown<T extends Enum> extends StatelessWidget {
  final String? labelText; // Optional label text above the dropdown
  final T? value; // Current selected value
  final List<T> items; // List of enum items
  final Function(T?) onChanged; // Callback when an item is selected
  final String? hintText; // Hint text for the dropdown
  final FormFieldValidator<T>? validator; // Validator for the dropdown
  final String Function(T)? displayNameMapper; // Function to map enum to display name

  const CustomEnumDropdown({
    super.key,
    this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.validator,
    this.displayNameMapper,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: EdgeInsets.only(bottom: 2.0.h),
            child: Text(
              labelText!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16.sp,
              ),
            ),
          ),
        SizedBox(
          width: double.infinity, 
          child: DropdownButtonFormField<T>(
            value: value,
            onChanged: onChanged,
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  displayNameMapper != null
                      ? displayNameMapper!(item) 
                      : item.name, 
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis, 
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 12.0.w),
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down), 
            iconSize: 24.sp, 
            iconEnabledColor: Colors.grey, 
            isExpanded: true, // Allow the dropdown to take up available width
            validator: validator,
          ),
        ),
      ],
    );
  }
}