import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/emailconfirmation/logic/cubit/email_confirmation_cubit.dart';
import 'package:joblinc/features/emailconfirmation/logic/cubit/email_confirmation_state.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final String email;

  EmailConfirmationScreen({super.key, required this.email});

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _showOtpField = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailConfirmationCubit, EmailConfirmationState>(
      listener: (context, state) {
        if (state is EmailConfirmationOtpSent) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );

          // Show OTP field when code is sent
          setState(() {
            _showOtpField = true;
          });
        } else if (state is EmailConfirmationVerified) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );

          // Navigate to login on successful verification
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(context, Routes.homeScreen);
          });
        } else if (state is EmailConfirmationFailure) {
          CustomSnackBar.show(
            context: context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: LoadingIndicatorOverlay(
            inAsyncCall: state is EmailConfirmationLoading,
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(10.sp, 0.1.sh, 10.sp, 16.0.sp),
                child: ListView(
                  children: [
                    Text(
                      "Verify your email",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "We've sent a confirmation code to:",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.crimsonRed,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Please check your email and enter the verification code below.",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    if (_showOtpField) ...[
                      SizedBox(height: 30.h),
                      Text(
                        "Enter verification code:",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        style: TextStyle(fontSize: 20.sp, letterSpacing: 8),
                        decoration: InputDecoration(
                          hintText: "000000",
                          border: OutlineInputBorder(),
                          counterText: "",
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: customRoundedButton(
                          key: Key('verify_code_button'),
                          text: "Verify Code",
                          backgroundColor: ColorsManager.crimsonRed,
                          borderColor: ColorsManager.crimsonRed,
                          foregroundColor: Colors.white,
                          onPressed: () {
                            if (_otpController.text.length < 6) {
                              CustomSnackBar.show(
                                context: context,
                                message: "Please enter a valid 6-digit code",
                                type: SnackBarType.error,
                              );
                              return;
                            }

                            context.read<EmailConfirmationCubit>().verifyEmail(
                                  email: widget.email,
                                  otp: _otpController.text,
                                );
                          },
                        ),
                      ),
                    ],
                    SizedBox(height: 40.h),
                    Text(
                      "Didn't receive the code?",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context
                                .read<EmailConfirmationCubit>()
                                .resendConfirmationEmail(widget.email);
                          },
                          child: Text(
                            "Resend confirmation code",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorsManager.crimsonRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: customRoundedButton(
                        key: Key('goto_login_button'),
                        text: "return to Login",
                        backgroundColor: Colors.grey,
                        borderColor: Colors.grey,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Routes.loginScreen);
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
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
