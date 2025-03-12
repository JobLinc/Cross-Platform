import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';

class ContinueSignButton extends StatelessWidget {
  const ContinueSignButton({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: customRoundedButton(
            text: "Continue",
            backgroundColor: ColorsManager.crimsonRed,
            borderColor: Colors.transparent,
            padding: EdgeInsets.only(left: 20, right: 20),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pushReplacementNamed(
                    context, Routes.homeScreen);
              }
            },
            foregroundColor: Colors.white),);
  }
}

