import 'package:flutter/material.dart';
import '../form/custom_text_field.dart';

class PhoneTextFormField extends StatelessWidget {
  const PhoneTextFormField({
    super.key,
    required TextEditingController phoneController,
  }) : _phoneController = phoneController;

  final TextEditingController _phoneController;

  @override
  Widget build(BuildContext context) {
    return CustomRectangularTextFormField(
        controller: _phoneController,
        hintText: "Enter a phone number",
        labelText: "Phone",
        maxLength: 11,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          }

          if (value.length != 4) {
            return 'Year must be a 4-digit number.';
          }

          int? year = int.tryParse(value);
          if (year == null) {
            return 'Enter a valid year.';
          }

          if (year < 1800 || year > 2030) {
            return 'Year must be between 1800 and 2030.';
          }
          return null;
        });
  }
}
