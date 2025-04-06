import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/changepassword/logic/cubit/change_password_cubit.dart';
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
        elevation: 1,
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(flex: 2, child: SizedBox()),
              CustomRoundedTextFormField(
                key: Key('changePassword_currentPassword_textfield'),
                controller: _currentPasswordController,
                labelText: 'Current Password',
                obscureText: true,
              ),
              Expanded(flex: 1, child: SizedBox()),
              CustomRoundedTextFormField(
                key: Key('changePassword_newPassword_textfield'),
                controller: _newPasswordController,
                labelText: 'New Password',
                obscureText: true,
              ),
              Expanded(flex: 1, child: SizedBox()),
              CustomRoundedTextFormField(
                key: Key('changePassword_confirmPassword_textfield'),
                controller: _confirmPasswordController,
                labelText: 'Confirm New Password',
                obscureText: true,
              ),
              Expanded(flex: 10, child: const SizedBox()),
              BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    CustomSnackBar.show(
                      context: context,
                      message: "Password changed successfully",
                      type: SnackBarType.success,
                    );
                  } else if (state is ChangePasswordFailure) {
                    CustomSnackBar.show(
                      context: context,
                      message: state.error,
                      type: SnackBarType.error,
                    );
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: customRoundedButton(
                      key: Key('changePassword_submit_button'),
                      foregroundColor: Colors.white,
                      backgroundColor: ColorsManager.crimsonRed,
                      borderColor: ColorsManager.crimsonRed,
                      width: 0.7.sw,
                      onPressed: state is ChangePasswordLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final oldPassword =
                                    _currentPasswordController.text;
                                final newPassword = _newPasswordController.text;
                                final confirmPassword =
                                    _confirmPasswordController.text;

                                if (newPassword != confirmPassword) {
                                  CustomSnackBar.show(
                                    context: context,
                                    message: "New passwords do not match",
                                    type: SnackBarType.error,
                                  );
                                  return;
                                }

                                context
                                    .read<ChangePasswordCubit>()
                                    .changePassword(
                                      oldPassword: oldPassword,
                                      newPassword: newPassword,
                                    );
                              }
                            },
                      text: state is ChangePasswordLoading
                          ? "Changing..."
                          : 'Change Password',
                    ),
                  );
                },
              ),
              Expanded(flex: 2, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
