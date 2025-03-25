import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/emailconfirmation/logic/cubit/email_confirmation_cubit.dart';
import 'package:joblinc/features/emailconfirmation/logic/cubit/email_confirmation_state.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final String email;

  const EmailConfirmationScreen({super.key, required this.email});

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    context.read<EmailConfirmationCubit>().setEmail(widget.email);
    _sendConfirmationEmail();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _sendConfirmationEmail() {
    context.read<EmailConfirmationCubit>().sendConfirmationEmail();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailConfirmationCubit, EmailConfirmationState>(
      listener: (context, state) {
        if (state is ConfirmationEmailSent) {
          setState(() {
            _emailSent = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Verification code sent to your email')),
          );
        } else if (state is SendConfirmationEmailFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send verification code: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is EmailConfirmed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email verified successfully!')),
          );
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is ConfirmEmailFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to verify email: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading =
            state is SendingConfirmationEmail || state is ConfirmingEmail;

        return LoadingIndicatorOverlay(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Image.asset(
                  'assets/images/JobLinc_logo_light.png',
                  width: 0.25.sw,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.sp, horizontal: 24.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verify Your Email",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.sp),
                  Text(
                    "We've sent a verification code to ${widget.email}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 30.sp),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Verification Code',
                            hintText: 'Enter the 6-digit code',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the verification code';
                            }
                            if (value.length < 6) {
                              return 'Please enter a valid verification code';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  Row(
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: _emailSent && !isLoading
                            ? _sendConfirmationEmail
                            : null,
                        child: Text(
                          "Resend",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: _emailSent && !isLoading
                                ? ColorsManager.crimsonRed
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.sp),
                  SizedBox(
                    width: double.infinity,
                    height: 50.sp,
                    child: customRoundedButton(
                      text: "Verify Email",
                      backgroundColor: ColorsManager.crimsonRed,
                      borderColor: Colors.transparent,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<EmailConfirmationCubit>()
                                    .confirmEmail(_otpController.text);
                              }
                            },
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
