import 'package:flutter/material.dart';
import '../form/custom_text_field.dart';

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
    );
  }
}
