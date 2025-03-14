import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_rounded_button.dart';
import 'package:joblinc/features/forgetpassword/ui/screens/change_password_view.dart';

class EnterCodeView extends StatelessWidget {
  const EnterCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _codeController = TextEditingController();

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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.sp, horizontal: 24.sp),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter the 6-digit code",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Check a******@gmail.com for a verification code.",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '6-digit code',
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Handle resend code
                },
                child: Text(
                  "Resend code",
                  style: TextStyle(
                    color: ColorsManager.crimsonRed,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: customRoundedButton(
                  text: "Submit",
                  backgroundColor: ColorsManager.crimsonRed,
                  borderColor: Colors.transparent,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordView()),
                    );
                  },
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Handle can't access this email
                },
                child: Text(
                  "Can't access this email?",
                  style: TextStyle(
                    color: ColorsManager.crimsonRed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
