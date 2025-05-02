import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/models/location_model.dart';

class CompanyHomePage extends StatelessWidget {
  final Company company;
  const CompanyHomePage({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // added to align cards left
        children: [
          // Biography Card
          Card(
            margin: EdgeInsets.all(12.w),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About Us',
                      style:
                          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text(
                    company.overview ?? 'No biography available.',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
          // Locations Card
          Card(
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Locations',
                      style:
                          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  if (company.locations == null || company.locations!.isEmpty)
                    Text('No locations available.',
                        style: TextStyle(fontSize: 14.sp))
                  else
                    ...company.locations!.map((loc) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on,
                                  color: ColorsManager.crimsonRed, size: 16),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  [
                                    if (loc.address != null) loc.address,
                                    if (loc.city != null) loc.city,
                                    if (loc.country != null) loc.country
                                  ].whereType<String>().join(', '),
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
