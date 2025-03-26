import 'package:flutter/material.dart';
import 'package:joblinc/features/companyPages/ui/widgets/company_data.dart';
import 'package:joblinc/features/companyPages/ui/widgets/homePage/about.dart';
import 'package:joblinc/features/companyPages/ui/widgets/homePage/posts.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../data/data/company.dart';
import '../widgets/scrollable_tabs.dart';

class CompanyPageHome extends StatefulWidget {
  final Company company;
  const CompanyPageHome({required this.company, super.key});

  @override
  _CompanyPageHomeState createState() => _CompanyPageHomeState();
}

class _CompanyPageHomeState extends State<CompanyPageHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  keyName: 'company',
                  text: widget.company.name,
                  onPress: () {},
                  onTextChange: (searched) {},
                  controller: TextEditingController(),
                ),
              ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyData(company: widget.company), // Company details
          ScrollableTabs(
              tabController:
                  _tabController
                ), 
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: Text("Home")),
                CompanyHomeAbout(company: widget.company),
                CompanyHomePosts(),
                Center(child: Text("Jobs")),
                Center(child: Text("People")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}