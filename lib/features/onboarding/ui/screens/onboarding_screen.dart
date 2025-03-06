import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_divider_text.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox()),
                    Container(
                      height: 100.h,
                      alignment: Alignment.center,
                      child: Image(
                        width: 0.55.sw,
                        fit: BoxFit.fitWidth,
                        image:
                            AssetImage('assets/images/JobLinc_logo_light.png'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "Join a trusted community of 1B professionals",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19.sp, // Responsive text size
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    customRoundedButton(
                        foregroundColor: Colors.black,
                        text: "Sign in with email ",
                        backgroundColor: Colors.transparent,
                        icon: Icons.email,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Routes.loginScreen);
                        }),
                    SizedBox(height: 20.h),
                    customRoundedButton(
                        foregroundColor: Colors.blue[800]!,
                        borderColor: Colors.blueAccent,
                        text: "Continue with google",
                        backgroundColor: Colors.transparent,
                        icon: FontAwesomeIcons.g,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Routes.homeScreen);
                        }),
                    customDividerWithText(child: Text("OR")),
                    customRoundedButton(
                        borderColor: ColorsManager.crimsonRed,
                        foregroundColor: ColorsManager.crimsonRed,
                        text: "Agree & Join",
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Routes.signUpScreen);
                        }),
                    Container(
                      width: 0.85.sw,
                      margin: EdgeInsets.symmetric(vertical: 20.sp),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                          children: [
                            TextSpan(
                                text:
                                    'By clicking Agree & Join or Continue, you agree to the Joblinc '),
                            TextSpan(
                              text: 'User Agreement',
                              style: TextStyle(
                                  color: ColorsManager.crimsonRed,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ', '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                  color: ColorsManager.crimsonRed,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ', and '),
                            TextSpan(
                              text: 'Cookie Policy',
                              style: TextStyle(
                                  color: ColorsManager.crimsonRed,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.white,
            ),
          );
        });
  }
}



  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       body: Center(
  //           child: Column(
  //         children: [
  //           const Text('Onboarding Screen'),

  //           // Navigations for testing screens while working on the app (will be removed later)
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.loginScreen);
  //               },
  //               child: const Text('Login')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.signUpScreen);
  //               },
  //               child: const Text('Signup')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.homeScreen);
  //               },
  //               child: const Text('Home')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.profileScreen);
  //               },
  //               child: const Text('Profile')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.chatScreen);
  //               },
  //               child: const Text('Chat')),
  //         ],
  //       )),
  //     ),
  //   );
  // }