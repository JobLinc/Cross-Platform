import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/signup/data/models/register_request_model.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_cubit.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_state.dart';
import 'package:joblinc/features/signup/ui/widgets/signup_step_one.dart';
import 'package:joblinc/features/signup/ui/widgets/signup_step_two.dart';
import 'package:joblinc/features/signup/ui/widgets/signup_step_three.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ViewModel-like state management
  final pageController = PageController();
  int currentPage = 0;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    countryController.dispose();
    cityController.dispose();
    phoneController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          CustomSnackBar.show(
            context: context,
            message: "Registration successful",
            type: SnackBarType.success,
          );
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is RegisterFailure) {
          CustomSnackBar.show(
            context: context,
            message: state.error,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return LoadingIndicatorOverlay(
          inAsyncCall: state is RegisterLoading,
          child: Scaffold(
            appBar: AppBar(
              elevation: 100,
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
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5.sp),
                      RichText(
                        key: Key('register_returnToLogin_textbutton'),
                        text: TextSpan(
                          children: [
                            const TextSpan(text: "or "),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.loginScreen);
                                },
                              text: "Sign in to JobLinc",
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
                      SizedBox(height: 40.sp),
                    ],
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SignupStepOne(
                          key: Key('register_step1_form'),
                          formKey: formKey1,
                          firstNameController: firstNameController,
                          lastNameController: lastNameController,
                        ),
                        SignupStepTwo(
                          key: Key('register_step2_form'),
                          formKey: formKey2,
                          emailController: emailController,
                          passwordController: passwordController,
                        ),
                        SignupStepThree(
                          key: Key('register_step3_form'),
                          formKey: formKey3,
                          countryController: countryController,
                          cityController: cityController,
                          phoneController: phoneController,
                        ),
                      ],
                    ),
                  ),
                  buildNavigationButtons(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void previousPage() {
    if (currentPage > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => currentPage--);
    }
  }

  void nextPage(BuildContext context) {
    if (currentPage == 0 && formKey1.currentState!.validate()) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => currentPage++);
    } else if (currentPage == 1 && formKey2.currentState!.validate()) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => currentPage++);
    }
  }

  Widget buildNavigationButtons(BuildContext context, RegisterState state) {
    final bool isLoading = state is RegisterLoading;

    return Row(
      children: [
        if (currentPage > 0)
          Expanded(
            child: customRoundedButton(
              key: Key('register_back_button'),
              borderColor: ColorsManager.mutedSilver,
              backgroundColor: ColorsManager.mutedSilver,
              foregroundColor: Colors.white,
              onPressed: isLoading ? null : previousPage,
              text: "Back",
            ),
          ),
        if (currentPage > 0) const SizedBox(width: 10),
        Expanded(
          child: customRoundedButton(
            key: Key('register_continue_button'),
            borderColor: ColorsManager.crimsonRed,
            backgroundColor: ColorsManager.crimsonRed,
            foregroundColor: ColorsManager.warmWhite,
            onPressed: isLoading
                ? null
                : () {
                    if (currentPage == 2) {
                      submit(context);
                    } else {
                      nextPage(context);
                    }
                  },
            text: currentPage == 2
                ? (isLoading ? "Submitting..." : "Submit")
                : (isLoading ? "Loading..." : "Continue"),
          ),
        ),
      ],
    );
  }

  void submit(BuildContext context) {
    if (formKey3.currentState!.validate()) {
      context.read<RegisterCubit>().register(
            RegisterRequestModel(
              firstname: firstNameController.text,
              lastname: lastNameController.text,
              email: emailController.text,
              password: passwordController.text,
              country: countryController.text,
              city: cityController.text,
              phoneNumber: phoneController.text,
            ),
          );
    }
  }
}
