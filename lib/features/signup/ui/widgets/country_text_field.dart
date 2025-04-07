import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:joblinc/core/helpers/countries.dart';

class CountryTextFormField extends StatelessWidget {
  const CountryTextFormField({
    super.key,
    required TextEditingController countryController,
  }) : _countryController = countryController;

  final TextEditingController _countryController;

  @override
  Widget build(BuildContext context) {
    // Set default value to Egypt if controller is empty
    if (_countryController.text.isEmpty) {
      _countryController.text = 'Egypt';
      // Notify city dropdown to update with Egypt as selected country
      Future.microtask(() {
        cityChangedNotifier.value = 'Egypt';
      });
    }

    // Get country list from the countries map
    final List<String> countryList = countries.keys.toList()..sort();

    // Use DropdownButtonFormField2 instead of DropdownButtonFormField
    return DropdownButtonFormField2<String>(
      dropdownStyleData: DropdownStyleData(
        maxHeight: 350.h,
        width: 1.sw - 32, // Match parent width minus padding
        direction: DropdownDirection.textDirection, // Follow text direction
        offset: const Offset(0, 0), // No offset
      ),
      isExpanded: true,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
      ),
      value: _countryController.text,
      decoration: const InputDecoration(
        labelText: 'Country',
        isDense: true, // More compact UI
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: countryList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your country';
        }
        return null;
      },
      onChanged: (String? newValue) {
        if (newValue != null) {
          _countryController.text = newValue;
          // Notify city dropdown to update
          cityChangedNotifier.value = newValue;
        }
      },
    );
  }
}

// ValueNotifier to communicate country changes to the city dropdown
final ValueNotifier<String> cityChangedNotifier = ValueNotifier<String>('');
