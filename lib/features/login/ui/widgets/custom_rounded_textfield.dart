import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomRoundedTextFormField extends StatelessWidget {
  CustomRoundedTextFormField(
      {super.key,
      required TextEditingController controller,
      this.obscureText,
      this.labelText,
      this.hintText,
      this.hintStyle,
      this.filled,
      this.borderRadius,
      this.validator,
      this.keyboardType})
      : _controller = controller;

  final TextEditingController _controller;

  String? labelText;
  String? hintText;
  TextStyle? hintStyle;
  BorderRadius? borderRadius;
  bool? filled;
  bool? obscureText;
  FormFieldValidator<String>? validator;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle,
        labelText: labelText ?? "",
        labelStyle: TextStyle(color: Colors.grey.shade500),
        filled: filled ?? true,
        fillColor: const Color.fromARGB(255, 244, 251, 255),
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}
