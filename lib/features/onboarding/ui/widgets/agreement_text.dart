import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';

class AgreementText extends StatelessWidget {
  const AgreementText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

