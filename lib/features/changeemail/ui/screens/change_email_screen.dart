import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/changeemail/data/repos/change_email_repo.dart';
import 'package:joblinc/features/changeemail/logic/cubit/change_email_cubit.dart';
import 'package:joblinc/features/changeemail/logic/cubit/change_email_state.dart';
import 'package:joblinc/features/signup/ui/widgets/email_text_field.dart';

class ChangeEmailScreen extends StatelessWidget {
  ChangeEmailScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangeEmailCubit, ChangeEmailState>(
      listener: (context, state) {
        if (state is ChangeEmailSuccess) {
          CustomSnackBar.show(
            context: context,
            message: 'Email updated successfully',
            type: SnackBarType.success,
          );

          // Navigate to email confirmation screen
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(
              context,
              Routes.emailConfirmationScreen,
              arguments: _emailController.text,
            );
          });
        } else if (state is ChangeEmailFailure) {
          CustomSnackBar.show(
            context: context,
            message: state.error,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Change Email"),
            backgroundColor: ColorsManager.softMutedSilver,
            elevation: 1,
          ),
          body: LoadingIndicatorOverlay(
            inAsyncCall: state is ChangeEmailLoading,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      "Enter your new email address",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "You'll need to verify your new email address after changing it.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    EmailTextFormField(
                      key: Key('change_email_textfield'),
                      emailController: _emailController,
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: double.infinity,
                      child: customRoundedButton(
                        key: Key('change_email_button'),
                        text: "Update Email",
                        backgroundColor: ColorsManager.crimsonRed,
                        borderColor: ColorsManager.crimsonRed,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final newEmail = _emailController.text.trim();
                            context
                                .read<ChangeEmailCubit>()
                                .updateEmail(newEmail);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
