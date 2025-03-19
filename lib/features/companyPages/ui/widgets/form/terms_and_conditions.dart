import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';

class TermsAndConditionsCheckBox extends StatefulWidget {
  const TermsAndConditionsCheckBox({super.key});

  @override
  State<TermsAndConditionsCheckBox> createState() =>
      TermsAndConditionsCheckBoxState();
}

class TermsAndConditionsCheckBoxState extends State<TermsAndConditionsCheckBox> {
  bool _isChecked = false;
  String? _errorText;

  void _onChanged(bool? value) {
    setState(() {
      _isChecked = value ?? false;
      // Show error if unchecked, regardless of previous state
      _errorText = _isChecked ? null : "Please approve the terms and conditions";
    });
  }

  String? validate() {
    if (!_isChecked) {
      setState(() {
        _errorText = "Please approve the terms and conditions";
      });
      return _errorText;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: _onChanged,
              checkColor: ColorsManager.warmWhite,
              focusColor: ColorsManager.crimsonRed,
              hoverColor: ColorsManager.crimsonRed,
              activeColor: ColorsManager.crimsonRed,
            ),
            Expanded(
              child: Text(
                "I verify that I am an authorized representative of this organization and I have the right to act on its behalf in the creation and management of this page. The organization and I agree to the additional terms for Pages.",
                style: TextStyle(
                  fontSize: 15.sp,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
        if (_errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: ColorsManager.crimsonRed,
                fontSize: 10.sp,
              ),
            ),
          ),
      ],
    );
  }
}