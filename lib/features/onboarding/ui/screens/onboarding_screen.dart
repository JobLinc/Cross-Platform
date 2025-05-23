import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_divider_text.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/login/logic/cubit/login_state.dart';
import 'package:joblinc/features/onboarding/ui/widgets/agreement_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
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
      } else if (state is LoginEmailNotConfirmed) {
        // Navigate to email confirmation screen
        Navigator.pushReplacementNamed(
          context,
          Routes.emailConfirmationScreen,
          arguments: state.email,
        );
      }
    }, builder: (context, state) {
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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
                    context.read<LoginCubit>().loginWithGoogle();
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
              AgreementText(),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      );
    });
  }
}
