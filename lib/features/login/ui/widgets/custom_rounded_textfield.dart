import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomRoundedTextFormField extends StatelessWidget {
  CustomRoundedTextFormField(
      {super.key,
      required TextEditingController controller,
      this.obscureText,
      this.hintText,
      this.validator})
      : _controller = controller;

  final TextEditingController _controller;
  String? hintText;
  bool? obscureText;
  FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: _controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          hintText: hintText ?? "",
          filled: true,
          fillColor: const Color.fromARGB(255, 244, 251, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        validator: validator);
  }
}
