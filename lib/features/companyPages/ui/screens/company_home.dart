import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companyPages/ui/widgets/company_data.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../widgets/square_avatar.dart';
import '../../data/company.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          home: CompanyPageHome(
            company: mockCompanies[6]
          ),
        );
      },
    );
  }
}

class CompanyPageHome extends StatelessWidget {
  final Company company;
  const CompanyPageHome({required this.company, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            CustomSearchBar(
              // TODO: Needs to be gray and to have a better height
              text: company.name, // Company Name goes here
              onPress: () {},
              onTextChange: (searched) {},
              controller: TextEditingController(),
            ),
          ],
        ),
      ),
      body: 
      CompanyData(
        company: company
      ),
    );
  }
}
