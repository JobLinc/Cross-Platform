import 'package:flutter/material.dart';
import '../form/custom_text_field.dart';

class YearTextFormField extends StatelessWidget {
  const YearTextFormField({
    super.key,
    required TextEditingController yearController,
  }) : _yearController = yearController;

  final TextEditingController _yearController;

  @override
  Widget build(BuildContext context) {
    return CustomRectangularTextFormField(
        controller: _yearController,
        hintText: "Enter a year",
        labelText: "Year founded",
        maxLength: 4,
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
