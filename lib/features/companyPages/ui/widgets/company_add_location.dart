import 'package:flutter/material.dart';
import 'package:joblinc/features/companypages/data/data/models/location_model.dart';

class CompanyAddLocation extends StatefulWidget {
  final List<CompanyLocationModel> locations;
  const CompanyAddLocation({super.key, required this.locations});

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
    if (widget.locations.isNotEmpty) {
      for (int i = 0; i < widget.locations.length; i++) {
        final loc = widget.locations[i];
        addressControllers.add(TextEditingController(text: loc.address ?? ""));
        cityControllers.add(TextEditingController(text: loc.city ?? ""));
        countryControllers.add(TextEditingController(text: loc.country ?? ""));
        if (loc.primary == "true") {
          primaryIndex = i;
        }
      }
    } else {
      addressControllers.add(TextEditingController());
      cityControllers.add(TextEditingController());
      countryControllers.add(TextEditingController());
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
      countryControllers.add(TextEditingController());
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
        city: cityControllers[i].text,
        country: countryControllers[i].text,
        primary: (primaryIndex == i).toString(),
      ));
    }
    return locations;
  }

  void saveLocations() {
    if (_formKey.currentState!.validate()) {
      final locations = getLocations();
      Navigator.pop(context, locations);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: addressControllers.length > 1
                                  ? () => removeLocation(index)
                                  : null,
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: addressControllers[index],
                          decoration: const InputDecoration(
                            labelText: "Address",
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Address required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: cityControllers[index],
                          decoration: const InputDecoration(
                            labelText: "City",
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "City required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: countryControllers[index],
                          decoration: const InputDecoration(
                            labelText: "Country",
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Country required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Location"),
                onPressed: addLocation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}