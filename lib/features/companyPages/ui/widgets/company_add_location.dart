import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/helpers/countries.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/companypages/data/data/models/location_model.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/custom_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/country_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/companypages/logic/cubit/edit_company_cubit.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';

class CompanyAddLocation extends StatefulWidget {
  final Company company;
  const CompanyAddLocation({super.key, required this.company});

  @override
  State<CompanyAddLocation> createState() => _CompanyAddLocationState();
}

class _CompanyAddLocationState extends State<CompanyAddLocation> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> addressControllers = [];
  List<TextEditingController> cityControllers = [];
  List<TextEditingController> countryControllers = [];
  int? primaryIndex;

  @override
  void initState() {
    super.initState();
    final locations = widget.company.locations ?? [];
    if (locations.isNotEmpty) {
      for (int i = 0; i < locations.length; i++) {
        final loc = locations[i];
        final countryList = countries.keys.toList();
        String? countryValue = (loc.country == null || loc.country!.isEmpty)
            ? "Egypt"
            : loc.country;
        if (countryValue != null && !countryList.contains(countryValue)) {
          countryValue = "Egypt";
        }
        String cityValue =
            (loc.city != null && loc.city!.isNotEmpty) ? loc.city! : "";
        addressControllers.add(TextEditingController(text: loc.address ?? ""));
        cityControllers.add(TextEditingController(text: cityValue));
        countryControllers.add(TextEditingController(text: countryValue));
        if (loc.primary == true) {
          primaryIndex = i;
        }
      }
      primaryIndex ??= 0;
    } else {
      addressControllers.add(TextEditingController());
      cityControllers.add(TextEditingController(text: ""));
      countryControllers.add(TextEditingController(text: "Egypt"));
      primaryIndex = 0;
    }
  }

  @override
  void dispose() {
    for (final c in addressControllers) {
      c.dispose();
    }
    for (final c in cityControllers) {
      c.dispose();
    }
    for (final c in countryControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void addLocation() {
    setState(() {
      addressControllers.add(TextEditingController());
      cityControllers.add(TextEditingController());
      countryControllers.add(TextEditingController(text: "Egypt"));
      if (addressControllers.length == 1) {
        primaryIndex = 0;
      }
    });
  }

  void removeLocation(int index) {
    setState(() {
      addressControllers[index].dispose();
      cityControllers[index].dispose();
      countryControllers[index].dispose();
      addressControllers.removeAt(index);
      cityControllers.removeAt(index);
      countryControllers.removeAt(index);
      if (primaryIndex == index) {
        primaryIndex = addressControllers.isNotEmpty ? 0 : null;
      } else if (primaryIndex != null && primaryIndex! > index) {
        primaryIndex = primaryIndex! - 1;
      }
    });
  }

  List<CompanyLocationModel> getLocations() {
    final List<CompanyLocationModel> locations = [];
    for (int i = 0; i < addressControllers.length; i++) {
      locations.add(CompanyLocationModel(
        address: addressControllers[i].text,
        city: cityControllers[i].text.isEmpty ? null : cityControllers[i].text,
        country: countryControllers[i].text.isEmpty
            ? "Egypt"
            : countryControllers[i].text,
        primary: (primaryIndex == i),
      ));
    }
    return locations;
  }

  void saveLocations() async{
    if (_formKey.currentState!.validate()) {
      final locations = getLocations().map((loc) => loc.toJson()).toList();

      // update in-memory immediately
      await context.read<EditCompanyCubit>().updateCompanyLocations(locations);
      widget.company.locations = getLocations();
      Navigator.pushReplacementNamed(context, Routes.companyPageHome,
          arguments: {'company': widget.company, 'isAdmin': true});
      
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditCompanyCubit>(
      create: (_) => getIt<EditCompanyCubit>(),
      child: BlocConsumer<EditCompanyCubit, EditCompanyState>(
        listener: (context, state) {
          if (state is EditCompanyFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is EditCompanySuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Company locations updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(
              context,
              Routes.companyPageHome,
              arguments: {'company': widget.company, 'isAdmin': true},
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Locations'),
              actions: [
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: saveLocations,
                  tooltip: 'Save Locations',
                )
              ],
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: addressControllers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio<int>(
                                    value: index,
                                    groupValue: primaryIndex,
                                    onChanged: (val) {
                                      setState(() {
                                        primaryIndex = val;
                                      });
                                    },
                                  ),
                                  const Text("Primary location"),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: addressControllers.length > 1
                                        ? () => removeLocation(index)
                                        : null,
                                  ),
                                ],
                              ),
                              CustomRectangularTextFormField(
                                controller: addressControllers[index],
                                labelText: "Address*",
                                hintText: "Enter address",
                                prefixIcon: const Icon(Icons.location_on),
                                maxLength: 500,
                                maxLines: 2,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "Address required";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.h),
                              CustomRectangularTextFormField(
                                controller: cityControllers[index],
                                labelText: "City*",
                                hintText: "Enter city",
                                prefixIcon: const Icon(Icons.location_city),
                                maxLength: 100,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "City is required";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.h),
                              CountryTextFormField(
                                key: Key(
                                    'company_location_country_textfield_$index'),
                                countryController: countryControllers[index],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("New Location"),
                      onPressed: addLocation,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
