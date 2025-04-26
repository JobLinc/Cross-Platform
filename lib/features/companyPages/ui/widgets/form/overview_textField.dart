import 'package:flutter/material.dart';
import '../form/custom_text_field.dart';

class OverviewTextFormField extends StatelessWidget {
  const OverviewTextFormField({
    super.key,
    required TextEditingController overviewController,
  }) : _overviewController = overviewController;

  final TextEditingController _overviewController;

  @override
  Widget build(BuildContext context) {
    return CustomRectangularTextFormField(
        controller: _overviewController,
        hintText: "Add an about us with a brief overview of your products and services",
        labelText: "Overview*",
        maxLines: 5,
        maxLength: 2000,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Overview of the company is required."; 
          }
          return null;
        });
  }
}
