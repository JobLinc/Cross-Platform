// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class SubmitCompany extends StatelessWidget {
  const SubmitCompany({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.onTap,

  }) : _formKey = formKey;
  final Function() onTap;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        "Create",
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 16, // modify responsiveness
        ),
      ),
    );
  }
}
