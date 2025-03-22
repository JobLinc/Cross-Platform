import 'package:flutter/material.dart';
import 'package:joblinc/features/signup/ui/widgets/country_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/city_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/phone_text_field.dart';

class SignupStepThree extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController countryController;
  final TextEditingController cityController;
  final TextEditingController phoneController;

  const SignupStepThree({
    super.key,
    required this.formKey,
    required this.countryController,
    required this.cityController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 3 of 3"),
          const SizedBox(height: 20),
          CountryTextFormField(
              key: Key('register_country_textfield'),
              countryController: countryController),
          const SizedBox(height: 15),
          CityTextFormField(
              key: Key('register_city_textfield'),
              cityController: cityController),
          const SizedBox(height: 15),
          PhoneTextFormField(
              key: Key('register_phone_textfield'),
              phoneController: phoneController),
        ],
      ),
    );
  }
}
