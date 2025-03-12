import 'package:flutter/material.dart';
import 'package:joblinc/features/login/ui/widgets/custom_rounded_textfield.dart';

class LastnameTextFormField extends StatelessWidget {
  const LastnameTextFormField({
    super.key,
    required TextEditingController lastNameController,
  }) : _lastNameController = lastNameController;

  final TextEditingController _lastNameController;

  @override
  Widget build(BuildContext context) {
    return CustomRoundedTextFormField(
        controller: _lastNameController,
        hintText: "Last Name",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your last name';
          }
          return null;
        });
  }
}
