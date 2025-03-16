import 'package:flutter/material.dart';
import '../form/custom_text_field.dart';

class CompanyNameTextFormField extends StatelessWidget {
  const CompanyNameTextFormField({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return CustomRectangularTextFormField(
        controller: _nameController,
        hintText: "Add your organization's name",
        labelText: "Name*",
        maxLength: 100,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a name.';
          } else if (value.length > 100) {
            return 'Your company name is too long.';
          }
          return null;
        });
  }
}
