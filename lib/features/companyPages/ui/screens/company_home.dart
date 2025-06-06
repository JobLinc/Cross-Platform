import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/ui/widgets/company_data.dart';
import 'package:joblinc/features/companypages/ui/widgets/dashboard/dashboard_appbar.dart';
import 'package:joblinc/features/companypages/ui/widgets/homePage/about.dart';
import 'package:joblinc/features/companypages/ui/widgets/homePage/company_jobs.dart';
import 'package:joblinc/features/companypages/ui/widgets/homePage/home.dart';
import 'package:joblinc/features/companypages/ui/widgets/homePage/posts.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../widgets/scrollable_tabs.dart';

class CompanyPageHome extends StatefulWidget {
  final Company company;
  final AuthService authService = getIt<AuthService>();
  final bool isAdmin;
  CompanyPageHome({required this.company, this.isAdmin = false, super.key});

  @override
  _CompanyPageHomeState createState() => _CompanyPageHomeState();
}

class _CompanyPageHomeState extends State<CompanyPageHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    if (widget.isAdmin) {
      widget.authService.refreshToken(companyId: widget.company.id);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.authService.refreshToken();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: widget.isAdmin
          ? DashboardAppbar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, size: 24.sp),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, Routes.homeScreen),
              ),
              company: widget.company,
              selectedValue: "Company Profile",
            )
          : AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 24.sp),
                onPressed: () =>
                    Navigator.pop(context),
              ),
              backgroundColor: const Color(0xFFFAFAFA),
              title: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.light
                                ? ColorsManager.lightGray
                                : ColorsManager.darkModeCardBackground,
                        keyName: 'home_topBar_search',
                        text: 'Search',
                        onPress: () {
                          Navigator.pushNamed(
                              context, Routes.companyListScreen);
                        },
                        onTextChange: () {},
                        controller: searchController,
                      ),
                  ),
                ],
              ),
              elevation: 0,
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyData(
            company: widget.company,
            isAdmin: widget.isAdmin,
          ), // Company details
          ScrollableTabs(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CompanyHomePage(company: widget.company),
                CompanyHomeAbout(company: widget.company),
                CompanyHomePosts(companyId: widget.company.id!),
                CompanyHomeJobs(
                    companyId: widget.company.id!, isAdmin: widget.isAdmin),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
