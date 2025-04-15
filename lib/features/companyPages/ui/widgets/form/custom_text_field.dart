import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRectangularTextFormField extends StatefulWidget {
  CustomRectangularTextFormField({
    super.key,
    required this.controller,
    this.obscureText,
    this.hintText,
    this.labelText,
    this.validator,
    this.maxLength,
    this.maxLines,
    this.initialValue,
    this.prefixIcon,
    this.readOnly,
    this.onTap, // Add onTap parameter
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool? obscureText;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final int? maxLines;
  final String? initialValue;
  final Icon? prefixIcon;
  final bool? readOnly;
  final VoidCallback? onTap; 

  @override
  _CustomRectangularTextFormFieldState createState() =>
      _CustomRectangularTextFormFieldState();
}

class _CustomRectangularTextFormFieldState
    extends State<CustomRectangularTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              widget.labelText!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16.sp,
              ),
            ),
          ),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText ?? false,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          initialValue: widget.initialValue,
          cursorColor: const Color(0xFFD72638),
          readOnly: widget.readOnly ?? false, // Ensure readOnly is respected
          onTap: widget.onTap, // Pass onTap to TextFormField
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            hintText: widget.hintText ?? "",
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
            counterText: widget.maxLength != null
                ? '${widget.controller.text.length}/${widget.maxLength}'
                : null,
            counterStyle:
                TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
            prefixIcon: widget.prefixIcon,
          ),
          validator: widget.validator,
          onChanged: (value) {
            // Update the state to rebuild the widget
            setState(() {});
          },
        ),
      ],
    );
  }
}
