import 'package:flutter/material.dart';
import 'package:joblinc/features/signup/ui/widgets/firstname_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/lastname_text_field.dart';

class SignupStepOne extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const SignupStepOne({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 1 of 3"),
          const SizedBox(height: 20),
          FirstnameTextFormField(firstNameController: firstNameController),
          const SizedBox(height: 15),
          LastnameTextFormField(lastNameController: lastNameController),
        ],
      ),
    );
  }
}
