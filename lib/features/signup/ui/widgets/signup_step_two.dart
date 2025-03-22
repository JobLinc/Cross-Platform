import 'package:flutter/material.dart';
import 'package:joblinc/features/signup/ui/widgets/email_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/password_text_field.dart';

class SignupStepTwo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignupStepTwo({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 2 of 3"),
          const SizedBox(height: 20),
          EmailTextFormField(
              key: Key('register_email_textfield'),
              emailController: emailController),
          const SizedBox(height: 15),
          PasswordTextFormField(
              key: Key('register_password_textfield'),
              passwordController: passwordController),
        ],
      ),
    );
  }
}
