import 'package:flutter/material.dart';
import 'package:joblinc/features/login/ui/widgets/custom_rounded_textfield.dart';

class PasswordTextFormField extends StatelessWidget {
  const PasswordTextFormField({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return CustomRoundedTextFormField(
        labelText: "Password",
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          // Password length validation
          if (value.length < 6) {
            return 'Password must be at least 6 characters long';
          }
          return null;
        },
        controller: _passwordController);
  }
}
