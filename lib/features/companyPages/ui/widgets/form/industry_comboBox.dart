import 'package:flutter/material.dart';
import '../../../data/data/company.dart';
import 'custom_combobox.dart';

class IndustryDropdown extends StatelessWidget {
  final String? labelText;
  final Industry? value; // Current selected value
  final Function(Industry?) onChanged; // Callback when an item is selected
  final String? hintText; // Hint text for the dropdown
  final FormFieldValidator<Industry>? validator; // Validator for the dropdown

  const IndustryDropdown({
    super.key,
    this.labelText,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.validator,
  });


  @override
  Widget build(BuildContext context) {
    return 
    CustomEnumDropdown<Industry>(
      labelText: "Industry*",
      value: value,
      items: Industry.values,
      onChanged: onChanged,
      hintText: "ex: Information Services",
      validator: (value) {
          if (value == null) {
            return 'Please select an industry.';
          }
          return null;
        },
        displayNameMapper: (item) => item.displayName,
      );
  }
}
