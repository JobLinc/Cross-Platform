import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class CompanyjobLincUrlTextFormField extends StatelessWidget {
  const CompanyjobLincUrlTextFormField({
    super.key,
    required TextEditingController jobLincUrlController,
  }) : _jobLincUrlController = jobLincUrlController;

  final TextEditingController _jobLincUrlController;

  @override
  Widget build(BuildContext context) {
    return CustomRectangularTextFormField(
      controller: _jobLincUrlController,
      hintText: "Add your unique JobLinc address",
      labelText: "joblinc.com/company/*",
      maxLength: 100,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the desired JobLinc address.';
        } else if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
          return 'Your URL can only use hyphen, numeric and lowercase alphabets';
        } else if (value.length > 100) {
          return 'Your URL is too long';
        }
        return null;
      },
    );
  }
}
