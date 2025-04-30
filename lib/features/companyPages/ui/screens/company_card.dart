import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/companypages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';
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
  List<Company> filteredCompanies = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCompanies();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void getCompanies() async {
    final companies = await CompanyRepositoryImpl(
      CompanyApiService(getIt<Dio>()),
    ).getAllCompanies();
    setState(() {
      companiesList = companies;
      filteredCompanies = companies;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCompanies = companiesList.where((company) {
        return company.name.toLowerCase().contains(query) ||
            (company.industry.displayName.toLowerCase().contains(query)) ||
            (company.location?.toLowerCase().contains(query) ?? false);
      }).toList();
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
                  onTextChange: (searched) {
                    _searchController.text = searched;
                  },
                  controller: _searchController,
                ),
              ),
            ],
          ),
        ),
        body: ListView.builder(
            itemCount: filteredCompanies.length,
            itemBuilder: (context, index) => CompanyCard(
                  itemIndex: index,
                  company: filteredCompanies[index],
                  press: () {
                    Navigator.pushNamed(
                      context,
                      Routes.companyPageHome,
                      arguments: filteredCompanies[index],
                    );
                  },
                )));
  }
}
