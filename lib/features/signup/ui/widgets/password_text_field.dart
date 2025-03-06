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
        hintText: "Password",
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        controller: _passwordController);
  }
}