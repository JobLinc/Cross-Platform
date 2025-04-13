import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:joblinc/core/helpers/countries.dart';
import 'package:joblinc/features/signup/ui/widgets/country_text_field.dart';

class CityTextFormField extends StatefulWidget {
  CityTextFormField({
    super.key,
    this.selectedCity,
    required TextEditingController cityController,
  }) : _cityController = cityController;

  final TextEditingController _cityController;
  String? selectedCity;

  @override
  State<CityTextFormField> createState() => _CityTextFormFieldState();
}

class _CityTextFormFieldState extends State<CityTextFormField> {
  String _selectedCountry = '';
  String? _selectedCity;
  List<String> _availableCities = [];

  @override
  void initState() {
    super.initState();
    // Initialize the selected city if provided
    if (widget.selectedCity != null && widget.selectedCity!.isNotEmpty) {
      _selectedCity = widget.selectedCity;
      widget._cityController.text = _selectedCity!;
    } else {
      _selectedCity = null;
    }

    // Listen for country changes
    cityChangedNotifier.addListener(_updateCities);

    // Initialize cities if country is already selected
    if (cityChangedNotifier.value.isNotEmpty) {
      // Save the current selectedCity before it gets reset in _updateCities
      String? tempSelectedCity = _selectedCity;
      _updateCities();

      // If we had a selectedCity, restore it and add to available cities if needed
      if (tempSelectedCity != null && tempSelectedCity.isNotEmpty) {
        if (!_availableCities.contains(tempSelectedCity)) {
          _availableCities.insert(0, tempSelectedCity);
        }
        _selectedCity = tempSelectedCity;
        widget._cityController.text = tempSelectedCity;
      }
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

      // Reset the selected city and clear the city controller
      _selectedCity = null;
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
      value:
          _selectedCity, // Ensure _selectedCity is used as the dropdown value
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
          value: value, // Correctly set the value for each item
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
        setState(() {
          _selectedCity = newValue; // Update _selectedCity
          widget._cityController.text = newValue ?? ''; // Sync with controller
        });
      },
    );
  }
}
