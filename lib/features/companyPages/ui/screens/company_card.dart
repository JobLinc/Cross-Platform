import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/core/routing/routes.dart';
import '../widgets/square_avatar.dart';

class CompanyCard extends StatelessWidget {
  final int? itemIndex;
  final Company company;
  final Function()? press;

  const CompanyCard(
      {super.key, this.itemIndex, required this.company, this.press});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SquareAvatar(
                  imageUrl: company.logoUrl ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfphRB8Syzj7jIYXedFOeVZwicec0QaUv2cBwPc0l7NnXdjBKpoL9nDSeX46Tich1Razk&usqp=CAU', // Default logo if null
                  size: 30.w,
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 230.w,
                  child: Column(
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 5.w,
                        runSpacing: 2.h,
                        children: [
                          Row(
                            children: [
                              Text(
                                company.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            company.industry.displayName,
                            style: TextStyle(
                                fontSize: 10.sp, color: Colors.grey.shade600),
                          ),
                          Icon(Icons.circle,
                              size: 3.sp, color: Colors.grey.shade600),
                          Text(
                            company.location ?? "Location not available",
                            style: TextStyle(
                                fontSize: 10.sp, color: Colors.grey.shade600),
                          ),
                          Icon(Icons.circle,
                              size: 3.sp, color: Colors.grey.shade600),
                          Text(
                            "37M followers", // TODO: Replace with actual followers
                            style: TextStyle(
                                fontSize: 10.sp, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[400],
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class CompanyList extends StatefulWidget {
  const CompanyList({super.key});

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  List<Company> companiesList = [];

  @override
  void initState() {
    super.initState();
    getCompanies();
  }

  void getCompanies() {
    setState(() {
      companiesList = List.from(mockCompanies);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAFAFA),
          title: Row(
            children: [
              Expanded(
                child: CustomSearchBar(
                  keyName: "company_searchbar_textfield",
                  text: "Search for a company...",
                  onPress: () {},
                  onTextChange: (searched) {},
                  controller: TextEditingController(),
                ),
              ),
            ],
          ),
        ),
        body: ListView.builder(
            itemCount: companiesList.length,
            itemBuilder: (context, index) => CompanyCard(
                  itemIndex: index,
                  company: companiesList[index],
                  press: () {
                    Navigator.pushNamed(
                      context,
                      Routes.companyPageHome,
                      arguments:
                          companiesList[index], // Pass the Company object
                    );
                  },
                )));
  }
}
