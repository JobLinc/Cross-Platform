import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/features/forgetpassword/ui/screens/enter_code_view.dart';
import 'package:joblinc/features/forgetpassword/ui/screens/enter_email_view.dart';
import 'package:joblinc/features/signup/ui/widgets/email_text_field.dart';

class ForgetpasswordScreen extends StatelessWidget {
  const ForgetpasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterEmailView();
  }
}
