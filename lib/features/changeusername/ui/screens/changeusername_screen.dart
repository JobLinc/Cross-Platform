import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/changeusername/logic/cubit/change_username_cubit.dart';
import 'package:joblinc/features/login/ui/widgets/custom_rounded_textfield.dart';

class ChangeUsernameScreen extends StatelessWidget {
  ChangeUsernameScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _newUsernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 1,
        title: const Text('Change Username'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(flex: 1, child: SizedBox()),
              Text(
                "Enter your new Username",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Expanded(flex: 1, child: SizedBox()),
              CustomRoundedTextFormField(
                key: Key('changeUsername_newUsername_textfield'),
                controller: _newUsernameController,
                labelText: 'New Username',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (value.length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  // Add regex validation for username format
                  RegExp validUsernamePattern = RegExp(r'^[a-z0-9-]+$');
                  if (!validUsernamePattern.hasMatch(value)) {
                    return 'No special characters or higher case letters allowed';
                  }
                  return null;
                },
              ),
              Expanded(flex: 10, child: const SizedBox()),
              BlocConsumer<ChangeUsernameCubit, ChangeUsernameState>(
                listener: (context, state) {
                  if (state is ChangeUsernameSuccess) {
                    CustomSnackBar.show(
                      context: context,
                      message: "Username changed successfully",
                      type: SnackBarType.success,
                    );
                    Navigator.pop(context);
                  } else if (state is ChangeUsernameFailure) {
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
                      key: Key('changeUsername_submit_button'),
                      foregroundColor: Colors.white,
                      backgroundColor: ColorsManager.crimsonRed,
                      borderColor: ColorsManager.crimsonRed,
                      width: 0.7.sw,
                      onPressed: state is ChangeUsernameLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final newUsername = _newUsernameController.text;

                                context
                                    .read<ChangeUsernameCubit>()
                                    .changeUsername(
                                      newUsername: newUsername,
                                    );
                              }
                            },
                      text: state is ChangeUsernameLoading
                          ? "Changing..."
                          : 'Change Username',
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
