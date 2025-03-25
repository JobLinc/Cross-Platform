import 'package:flutter/material.dart';
import 'package:joblinc/features/login/ui/widgets/custom_rounded_textfield.dart';

class PhoneTextFormField extends StatelessWidget {
  const PhoneTextFormField({
    super.key,
    required TextEditingController phoneController,
  }) : _phoneController = phoneController;

  final TextEditingController _phoneController;

  @override
  Widget build(BuildContext context) {
    return CustomRoundedTextFormField(
      controller: _phoneController,
      labelText: "Phone Number (Optional)",
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Enter a valid phone number';
          }
        }
        return null; // It's fine if it's empty!
      },
    );
  }
}
