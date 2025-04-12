import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:joblinc/core/helpers/countries.dart';
import 'package:joblinc/features/signup/ui/widgets/country_text_field.dart';

class CityTextFormField extends StatefulWidget {
  const CityTextFormField({
    super.key,
    required TextEditingController cityController,
  }) : _cityController = cityController;

  final TextEditingController _cityController;

  @override
  State<CityTextFormField> createState() => _CityTextFormFieldState();
}

class _CityTextFormFieldState extends State<CityTextFormField> {
  String _selectedCountry = '';
  List<String> _availableCities = [];

  @override
  void initState() {
    super.initState();
    // Listen for country changes
    cityChangedNotifier.addListener(_updateCities);

    // Initialize cities if country is already selected
    if (cityChangedNotifier.value.isNotEmpty) {
      _updateCities();
    }
  }

  @override
  void dispose() {
    cityChangedNotifier.removeListener(_updateCities);
    super.dispose();
  }

  void _updateCities() {
    setState(() {
      _selectedCountry = cityChangedNotifier.value;

      // Clear the city value when the country changes
      widget._cityController.text = '';

      // Get cities for selected country from countries map
      _availableCities = [];
      if (_selectedCountry.isNotEmpty &&
          countries.containsKey(_selectedCountry)) {
        _availableCities = countries[_selectedCountry]!.toList()..sort();
      } else {
        _availableCities = ['Select a country first'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      value: widget._cityController.text.isNotEmpty
          ? widget._cityController.text
          : null,
      decoration: const InputDecoration(
        labelText: 'City',
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: _availableCities.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your city';
        }
        return null;
      },
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            widget._cityController.text = newValue;
          });
        }
      },
    );
  }
}
