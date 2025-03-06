import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_divider_text.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/features/signup/ui/widgets/email_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/password_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMeCheck = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        body: Padding(
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
                  text: TextSpan(
                    children: [
                      TextSpan(text: "or "),
                      TextSpan(
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
                      EmailTextFormField(emailController: _emailController),
                     const SizedBox(height: 15),
                     PasswordTextFormField(passwordController: _passwordController),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.forgotPasswordScreen);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorsManager.softRosewood,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          rememberMeCheck = !rememberMeCheck;
                        }),
                        child: Row(
                          children: [
                            Checkbox(
                              value: rememberMeCheck,
                              onChanged: (value) {
                                setState(() {
                                  rememberMeCheck = value!;
                                });
                              },
                              activeColor: Colors
                                  .blue, // Change this to match your theme
                            ),
                            Text("Remember Me", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: customRoundedButton(
                              text: "Continue",
                              backgroundColor: ColorsManager.crimsonRed,
                              borderColor: Colors.transparent,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.homeScreen);
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
  }
}
