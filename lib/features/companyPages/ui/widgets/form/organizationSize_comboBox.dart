import 'package:flutter/material.dart';
import '../../../data/company.dart';
import 'custom_combobox.dart';

class OrganizationSizeDropdown extends StatelessWidget {
  final String? labelText;
  final OrganizationSize? value;
  final Function(OrganizationSize?) onChanged;
  final String? hintText;
  final FormFieldValidator<OrganizationSize>? validator;

  const OrganizationSizeDropdown({
    super.key,
    this.labelText,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomEnumDropdown<OrganizationSize>(
      key: Key("createcompany_organizationsize_dropdown"),
      labelText: "Organization size*",
      value: value,
      items: OrganizationSize.values,
      onChanged: onChanged,
      hintText: "Select size",
      validator: (value) {
        if (value == null) {
          return 'Please select an organization size.';
        }
        return null;
      },
      displayNameMapper: (item) => item.displayName,
    );
  }
}
