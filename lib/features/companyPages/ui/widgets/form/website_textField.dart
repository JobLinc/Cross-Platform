import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class CompanyWebsiteTextFormField extends StatelessWidget {
  const CompanyWebsiteTextFormField({
    super.key,
    required TextEditingController websiteController,
  }) : _websiteController = websiteController;

  final TextEditingController _websiteController;

  @override
  Widget build(BuildContext context) {
      return CustomRectangularTextFormField(
          controller: _websiteController,
          hintText: "Begin with http://, https:// or www.",
          labelText: "Website",
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!(value.startsWith('http://') ||
                  value.startsWith('https://') ||
                  value.startsWith('www.'))) {
                return 'Website must start with http://, https://, or www.';
              }
            }
            return null;
          }
    );
  }
}
