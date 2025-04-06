import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_divider_text.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/login/logic/cubit/login_state.dart';
import 'package:joblinc/features/signup/ui/widgets/email_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/password_text_field.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          // Loading state handled by LoadingIndicatorOverlay
        } else if (state is LoginSuccess) {
          CustomSnackBar.show(
            context: context,
            message: "Login successful",
            type: SnackBarType.success,
          );
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is LoginFailure) {
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
            elevation: 0,
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(
                width: 0.25.sw,
                'assets/images/JobLinc_logo_light.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          body: LoadingIndicatorOverlay(
            inAsyncCall: state is LoginLoading,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.sp, horizontal: 24.sp),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign in",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      key: Key("joinJobLinc"),
                      text: TextSpan(
                        children: [
                          TextSpan(text: "or "),
                          TextSpan(
                            semanticsLabel: "joinJobLinc",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                    context, Routes.signUpScreen);
                              },
                            text: "Join JobLinc",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.crimsonRed,
                            ),
                          ),
                        ],
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: customRoundedButton(
                          width: 0.9.sw,
                          foregroundColor: Colors.black,
                          borderColor: Colors.blueAccent,
                          text: "Sign in with google",
                          backgroundColor: Colors.transparent,
                          icon: FontAwesomeIcons.g,
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Routes.homeScreen);
                          }),
                    ),
                    const SizedBox(height: 20),
                    customDividerWithText(child: Text("or")),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EmailTextFormField(
                              key: Key("login_email_textfield"),
                              emailController: _emailController),
                          const SizedBox(height: 15),
                          PasswordTextFormField(
                              key: Key("login_password_textfield"),
                              passwordController: _passwordController),
                          const SizedBox(height: 10),
                          GestureDetector(
                            key: Key("login_forgotpassword_textButton"),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.forgotPasswordScreen);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                key: Key("login_forgotpassword_text"),
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorsManager.softRosewood,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: customRoundedButton(
                                  key: Key("login_continue_button"),
                                  text: "Continue",
                                  backgroundColor: ColorsManager.crimsonRed,
                                  borderColor: Colors.transparent,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final email = _emailController.text;
                                      final password = _passwordController.text;

                                      context
                                          .read<LoginCubit>()
                                          .login(email, password);
                                    }
                                  },
                                  foregroundColor: Colors.white)),
                        ],
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
