import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_state.dart';

class ForgotPasswordSteps extends StatefulWidget {
  const ForgotPasswordSteps({Key? key}) : super(key: key);

  @override
  _ForgotPasswordStepsState createState() => _ForgotPasswordStepsState();
}

class _ForgotPasswordStepsState extends State<ForgotPasswordSteps> {
  int _currentStep = 0;
  String email = '';
  String forgotToken = '';
  String resetToken = '';

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordEmailSent) {
          forgotToken = state.forgotToken;
          CustomSnackBar.show(
            context: context,
            message: "OTP sent to your email",
            type: SnackBarType.success,
          );
          setState(() => _currentStep = 1);
        } else if (state is ForgotPasswordOtpVerified) {
          resetToken = state.resetToken;
          CustomSnackBar.show(
            context: context,
            message: "OTP verified successfully",
            type: SnackBarType.success,
          );
          setState(() => _currentStep = 2);
        } else if (state is ForgotPasswordSuccess) {
          CustomSnackBar.show(
            context: context,
            message: "Password reset successfully!",
            type: SnackBarType.success,
          );
          Navigator.pop(context);
        } else if (state is ForgotPasswordError) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Forgot Password"),
            backgroundColor: ColorsManager.softMutedSilver,
            elevation: 10,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stepper(
              key: Key('forgotPassword_stepper'),
              connectorColor: WidgetStateColor.resolveWith(
                  (states) => ColorsManager.crimsonRed),
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: _handleContinue,
              onStepCancel: _handleCancel,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  children: [
                    ElevatedButton(
                      key: Key('forgotPassword_continue_button'),
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.crimsonRed,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Continue'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      key: Key('forgotPassword_cancel_button'),
                      onPressed: details.onStepCancel,
                      style: TextButton.styleFrom(
                        foregroundColor: ColorsManager.crimsonRed,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              },
              stepIconBuilder: (index, state) {
                return CircleAvatar(
                  backgroundColor: _currentStep == index
                      ? ColorsManager.crimsonRed
                      : Colors.grey,
                  child: Text('${index + 1}'),
                );
              },
              steps: [
                Step(
                  title: const Text("Enter Email"),
                  content: TextField(
                    key: Key('forgotPassword_email_textfield'),
                    controller: emailController,
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorsManager.darkBurgundy)),
                        labelStyle: TextStyle(color: ColorsManager.mutedSilver),
                        labelText: "Email",
                        focusColor: ColorsManager.crimsonRed,
                        fillColor: ColorsManager.crimsonRed,
                        hoverColor: ColorsManager.crimsonRed),
                  ),
                  isActive: _currentStep >= 0,
                  state:
                      _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text("Enter OTP"),
                  content: TextField(
                    key: Key('forgotPassword_otp_textfield'),
                    style: TextStyle(letterSpacing: 20.sp, fontSize: 30.sp),
                    controller: otpController,
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorsManager.darkBurgundy)),
                        labelStyle: TextStyle(color: ColorsManager.mutedSilver),
                        labelText: "OTP",
                        focusColor: ColorsManager.crimsonRed,
                        fillColor: ColorsManager.crimsonRed,
                        hoverColor: ColorsManager.crimsonRed),
                    maxLength: 6,
                  ),
                  isActive: _currentStep >= 1,
                  state:
                      _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text("Reset Password"),
                  content: TextField(
                    key: Key('forgotPassword_newPassword_textfield'),
                    controller: passwordController,
                    decoration:
                        const InputDecoration(labelText: "New Password"),
                    obscureText: true,
                  ),
                  isActive: _currentStep >= 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleContinue() {
    if (_currentStep == 0) {
      email = emailController.text.trim();
      context.read<ForgetPasswordCubit>().sendEmail(email);
    } else if (_currentStep == 1) {
      final otp = otpController.text.trim();
      context.read<ForgetPasswordCubit>().verifyOtp(email, forgotToken, otp);
    } else if (_currentStep == 2) {
      final newPassword = passwordController.text.trim();
      context
          .read<ForgetPasswordCubit>()
          .resetPassword(email, newPassword, resetToken);
    }
  }

  void _handleCancel() {
    if (_currentStep == 0) {
      Navigator.pop(context); // Exit the screen
    } else {
      setState(() => _currentStep -= 1); // Go back one step
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
