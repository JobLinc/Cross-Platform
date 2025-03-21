import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/features/login/ui/widgets/custom_rounded_textfield.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(
          'Change Password',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            CustomRoundedTextFormField(
              controller: _currentPasswordController,
              labelText: 'Current Password',
              obscureText: true,
            ),
            Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            CustomRoundedTextFormField(
              controller: _newPasswordController,
              labelText: 'New Password',
              obscureText: true,
            ),
            Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            CustomRoundedTextFormField(
              controller: _confirmPasswordController,
              labelText: 'Confirm New Password',
              obscureText: true,
            ),
            Expanded(
              child: const SizedBox(),
              flex: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: customRoundedButton(
                foregroundColor: Colors.white,
                backgroundColor: ColorsManager.crimsonRed,
                borderColor: ColorsManager.crimsonRed,
                width: 0.7.sw,
                onPressed: () {
                  // Implement change password logic here
                },
                text: ('Change Password'),
              ),
            ),
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
