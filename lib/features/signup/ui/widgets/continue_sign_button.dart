import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';

class ContinueSignButton extends StatelessWidget {
  const ContinueSignButton({
    super.key,
    required this.onPressed,
  });
  final Function() onPressed;

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
          onPressed: onPressed,
          foregroundColor: Colors.white),
    );
  }
}
