import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DropDownTextFormField extends StatelessWidget {
  final String fieldName;
  const DropDownTextFormField({
    super.key,
    required this.fieldName,
    required TextEditingController choiceController,
  }) : _choiceController = choiceController;

  final TextEditingController _choiceController;

  @override
  Widget build(BuildContext context) {
    // Set default value to Egypt if controller is empty
    // if (_countryController.text.isEmpty) {
    //   _countryController.text = 'Egypt';
    //   // Notify city dropdown to update with Egypt as selected country
    //   Future.microtask(() {
    //     cityChangedNotifier.value = 'Egypt';
    //   });
    // }


    List<String> dropDownList =[];
    if(fieldName=="Experience Level") dropDownList=allLists[0]; 
    if(fieldName=="Job Type") dropDownList=allLists[1]; 
    if(fieldName=="Workplace") dropDownList=allLists[2]; 

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
      value:null,
      decoration: InputDecoration(
        labelText: fieldName,
        isDense: true, // More compact UI
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: dropDownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your $fieldName';
        }
        return null;
      },
      onChanged: (newValue) {
        //if (newValue != null) {
          _choiceController.text = newValue!;
          // Notify city dropdown to update
          //cityChangedNotifier.value = newValue;
        //}
      },
    );
  }
}

 //ValueNotifier to communicate country changes to the city dropdown
final ValueNotifier<String> currencyChangedNotifier = ValueNotifier<String>('');


class CurrencyDropDownTextFormField extends StatelessWidget {
  final String fieldName;
  const CurrencyDropDownTextFormField({
    super.key,
    required this.fieldName,
    required TextEditingController currencyController,
  }) : _currencyController = currencyController;

  final TextEditingController _currencyController;

  @override
  Widget build(BuildContext context) {
    //Set default value to Egypt if controller is empty
    if ( _currencyController.text.isEmpty) {
       _currencyController.text = 'EGP';
      // Notify city dropdown to update with Egypt as selected country
      //Future.microtask(() {
         currencyChangedNotifier.value = 'EGP';
      // });
    }


    List<String> dropDownList = currencyCodes;

    // Use DropdownButtonFormField2 instead of DropdownButtonFormField
    return DropdownButtonFormField2<String>(
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200.h,
        // width: 1.sw - 99, // Match parent width minus padding
        direction: DropdownDirection.textDirection, // Follow text direction
        offset: const Offset(0, 0), // No offset
      ),
      isExpanded: true,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 0),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
      ),
      value:null,
      decoration:_inputDecoration(fieldName),
      // decoration: InputDecoration(
      //   labelText: fieldName,
      //   isDense: true, // More compact UI
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
      //   ),
      //   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // ),
      items: dropDownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your $fieldName';
        }
        return null;
      },
      onChanged: (String? newValue) {
        if (newValue != null) {
           _currencyController.text = newValue;
          // Notify city dropdown to update
          currencyChangedNotifier.value = newValue;
        }
      },
    );
  }
}

List<List<String>> allLists=[
  ["Freshman","Junior","MidLevel","Senior"],
  ["Full-time","Part-time","Contract","Internship","Temporary","Volunteer"],
  ["Remote","Onsite","Hybrid"],
];

List<String> currencyCodes= [
  "AED", "AFN", "ALL", 
  "AMD", "ANG", "AOA", 
  "ARS", "AUD", "AWG", 
  "AZN", "BAM", "BBD", 
  "BDT", "BGN", "BHD", 
  "BIF", "BMD", "BND", 
  "BOB", "BOV", "BRL", 
  "BSD", "BTN", "BWP", 
  "BYR", "BZD", "CAD", 
  "CDF", "CHE", "CHF", 
  "CHW", "CLF", "CLP", 
  "CNY", "COP", "COU", 
  "CRC", "CUC",  "CUP", 
  "CVE", "CZK", "DJF", 
  "DKK", "DOP", "DZD", 
  "EGP", "ERN", "ETB", 
  "EUR", "FJD", "FKP", 
  "GBP", "GEL", "GHS", 
  "GIP", "GMD", "GNF", 
  "GTQ", "GYD", "HKD",  
  "HNL", "HRK", "HTG", 
  "HUF", "IDR", "ILS", 
  "INR", "IQD", "IRR", 
  "ISK", "JMD", "JOD", 
  "JPY", "KES", "KGS", 
  "KHR", "KMF", "KPW", 
  "KRW", "KWD", "KYD", 
  "KZT", "LAK", "LBP", 
  "LKR", "LRD", "LSL", 
  "LTL", "LVL", "LYD", 
  "MAD", "MDL", "MGA", 
  "MKD", "MMK", "MNT", 
  "MOP", "MRO", "MUR", 
  "MVR", "MWK", "MXN", 
  "MXV", "MYR", "MZN", 
  "NAD", "NGN", "NIO", 
  "NOK", "NPR", "NZD", 
  "OMR", "PAB", "PEN", 
  "PGK", "PHP", "PKR", 
  "PLN", "PYG", "QAR", 
  "RON", "RSD", "RUB", 
  "RWF", "SAR", "SBD", 
  "SCR", "SDG", "SEK", 
  "SGD", "SHP", "SLL", 
  "SOS", "SRD", "SSP", 
  "STD", "SYP", "SZL", 
  "THB", "TJS", "TMT", 
  "TND", "TOP", "TRY", 
  "TTD", "TWD", "TZS", 
  "UAH", "UGX", "USD", 
  "USN", "USS", "UYI", 
  "UYU", "UZS", "VEF", 
  "VND", "VUV", "WST", 
  "XAF", "XAG", "XAU", 
  "XBA", "XBB", "XBC", 
  "XBD", "XCD", "XDR", 
  "XFU", "XOF", "XPD", 
  "XPF", "XPT", "XTS", 
  "XXX", "YER", "ZAR", 
  "ZMW"];


  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black, fontSize: 14.sp,overflow: TextOverflow.ellipsis),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
    );
  }

// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';


// class DropdownCheckList extends StatefulWidget {
//   final List<String> items;
//   final ValueChanged<List<String>>? onSelectionChanged;

//   const DropdownCheckList({
//     Key? key,
//     required this.items,
//     this.onSelectionChanged,
//   }) : super(key: key);

//   @override
//   _DropdownCheckListState createState() => _DropdownCheckListState();
// }

// class _DropdownCheckListState extends State<DropdownCheckList> {
//   final List<String> _selected = [];

//   void _onItemToggled(String item, bool checked) {
//     setState(() {
//       if (checked) {
//         _selected.add(item);
//       } else {
//         _selected.remove(item);
//       }
//     });
//     widget.onSelectionChanged?.call(_selected);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: widget.items.map((item) {
//         final isChecked = _selected.contains(item);
//         return CheckboxListTile(
//           title: Text(item),
//           value: isChecked,
//           onChanged: (checked) => _onItemToggled(item, checked!),
//         );
//       }).toList(),
//     );
//   }
// }
// // 
// // class DropdownCheckList extends StatefulWidget {
// //   final List<String> countryList;
// //   final ValueChanged<List<String>>? onSelectionChanged;

// //   const DropdownCheckList({
// //     Key? key,
// //     required this.countryList,
// //     this.onSelectionChanged,
// //   }) : super(key: key);

// //   @override
// //   _DropdownCheckListState createState() =>
// //       _DropdownCheckListState();
// // }

// // class _DropdownCheckListState
// //     extends State<DropdownCheckList> {
// //   final List<String> _selected = [];

// //   @override
// //   Widget build(BuildContext context) {
// //     return DropdownButtonFormField2<String>(
// //       // the form-field decoration around the closed button
// //       decoration: InputDecoration(
// //         labelText: '',
// //         isDense: true,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(10.r),
// //         ),
// //         contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
// //       ),

// //       // the data that controls the button itself
// //       buttonStyleData: ButtonStyleData(
// //         height: 50.h,
// //         padding: EdgeInsets.only(right: 8.w),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(10.r),
// //         ),
// //       ),

// //       // the data that controls the drop-down panel
// //       dropdownStyleData: DropdownStyleData(
// //         maxHeight: 350.h,
// //         width: 1.sw - 32, 
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(10.r),
// //         ),
// //       ),

// //       iconStyleData: const IconStyleData(
// //         icon: Icon(Icons.arrow_drop_down),
// //         iconSize: 24,
// //       ),

// //       isExpanded: true,
// //       onChanged: (_) {},      // keep menu open by handling change yourself
// //       // validator: (_) {
// //       //   if (_selected.isEmpty) return 'Please select at least one country';
// //       //   return null;
// //       // },

// //       // build each menu item as a checkbox + label
// //       items: widget.countryList.map((country) {
// //         return DropdownMenuItem<String>(
// //           value: country,
// //           child: StatefulBuilder(
// //             builder: (context, menuSetState) {
// //               final checked = _selected.contains(country);
// //               return InkWell(
// //                 onTap: () {
// //                   if (checked) _selected.remove(country);
// //                   else _selected.add(country);
// //                   menuSetState(() {});    // rebuild this item
// //                   setState(() {});        // rebuild button label
// //                   widget.onSelectionChanged?.call(_selected);
// //                 },
// //                 child: Row(
// //                   children: [
// //                     Checkbox(value: checked, onChanged: (v) {
// //                       if (v == true) _selected.add(country);
// //                       else _selected.remove(country);
// //                       menuSetState(() {});
// //                       setState(() {});
// //                       widget.onSelectionChanged?.call(_selected);
// //                     }),
// //                     SizedBox(width: 8.w),
// //                     Expanded(child: Text(country)),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         );
// //       }).toList(),

// //       // show comma-joined selections in the closed button
// //       selectedItemBuilder: (context) {
// //         return widget.countryList.map((_) {
// //           return Text(
// //             _selected.join(', '),
// //             overflow: TextOverflow.ellipsis,
// //           );
// //         }).toList();
// //       },
// //     );
// //   }
// // }
// //   Widget build(BuildContext context) {
// //     return DropdownButtonFormField2<String>(
// //       isExpanded: true,
// //       // leave onChanged empty so the menu does not auto-close
// //       onChanged: (_) {},
// //       // display the comma-joined selection in the button
// //       buttonDecoration: InputDecoration(
// //         labelText: 'Country',
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //       ),
// //       buttonHeight: 50,
// //       dropdownMaxHeight: 300,
// //       dropdownWidth: MediaQuery.of(context).size.width - 32,
// //       dropdownDecoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       // build each menu item as a checkbox + label
// //       items: widget.countryList.map((country) {
// //         return DropdownMenuItem<String>(
// //           value: country,
// //           // use StatefulBuilder so we can rebuild the checkbox when tapped
// //           child: StatefulBuilder(
// //             builder: (context, menuSetState) {
// //               final isChecked = _selected.contains(country);
// //               return InkWell(
// //                 onTap: () {
// //                   if (isChecked) {
// //                     _selected.remove(country);
// //                   } else {
// //                     _selected.add(country);
// //                   }
// //                   // rebuild just this menu item
// //                   menuSetState(() {});
// //                   // rebuild the button label
// //                   setState(() {});
// //                   // notify listener
// //                   widget.onSelectionChanged?.call(_selected);
// //                 },
// //                 child: Row(
// //                   children: [
// //                     Checkbox(
// //                       value: isChecked,
// //                       onChanged: (v) {
// //                         if (v == true) {
// //                           _selected.add(country);
// //                         } else {
// //                           _selected.remove(country);
// //                         }
// //                         menuSetState(() {});
// //                         setState(() {});
// //                         widget.onSelectionChanged?.call(_selected);
// //                       },
// //                     ),
// //                     SizedBox(width: 8),
// //                     Expanded(child: Text(country)),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         );
// //       }).toList(),
// //       // show the selected items as comma-separated in the closed button
// //       selectedItemBuilder: (context) {
// //         return widget.countryList.map((country) {
// //           return Text(
// //             _selected.join(', '),
// //             overflow: TextOverflow.ellipsis,
// //           );
// //         }).toList();
// //       },
// //       validator: (val) {
// //         if (_selected.isEmpty) return 'Please select at least one country';
// //         return null;
// //       },
// //     );
// //   }
// // }
