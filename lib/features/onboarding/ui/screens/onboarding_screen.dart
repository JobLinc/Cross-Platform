import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_divider_text.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/features/onboarding/ui/widgets/agreement_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                image: AssetImage('assets/images/JobLinc_logo_light.png'),
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
                  Navigator.pushReplacementNamed(context, Routes.loginScreen);
                }),
            SizedBox(height: 20.h),
            customRoundedButton(
                foregroundColor: Colors.blue[800]!,
                borderColor: Colors.blueAccent,
                text: "Continue with google",
                backgroundColor: Colors.transparent,
                icon: FontAwesomeIcons.g,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.homeScreen);
                }),
            customDividerWithText(child: Text("OR")),
            customRoundedButton(
                borderColor: ColorsManager.crimsonRed,
                foregroundColor: ColorsManager.crimsonRed,
                text: "Agree & Join",
                backgroundColor: Colors.transparent,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.signUpScreen);
                }),
            AgreementText(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
