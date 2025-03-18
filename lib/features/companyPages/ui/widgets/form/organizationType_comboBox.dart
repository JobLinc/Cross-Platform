import 'package:flutter/material.dart';
import '../../../data/data/company.dart';
import 'custom_combobox.dart';

class OrganizationTypeDropdown extends StatelessWidget {
  final String? labelText;
  final OrganizationType? value; // Current selected value
  final Function(OrganizationType?) onChanged; // Callback when an item is selected
  final String? hintText; // Hint text for the dropdown
  final FormFieldValidator<OrganizationType>? validator; // Validator for the dropdown

  const OrganizationTypeDropdown({
    super.key,
    this.labelText,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: CustomEnumDropdown<OrganizationType>(
        key: Key("createcomapny_organizationtype_dropdown"),
        labelText: "Organization type*",
        value: value,
        items: OrganizationType.values,
        onChanged: onChanged,
        hintText: "Select Type",
        validator: (value) {
            if (value == null) {
              return 'Please select an organization type.';
            } 
            return null;
          },
        displayNameMapper: (item) => item.displayName,
      ),
    );
  }
}
