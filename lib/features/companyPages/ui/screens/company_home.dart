import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companyPages/ui/widgets/company_data.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../data/company.dart';
import '../widgets/scrollable_tabs.dart';

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
            company: mockCompanies[5],
          ),
        );
      },
    );
  }
}

class CompanyPageHome extends StatefulWidget {
  final Company company;
  const CompanyPageHome({required this.company, super.key});

  @override
  _CompanyPageHomeState createState() => _CompanyPageHomeState();
}

class _CompanyPageHomeState extends State<CompanyPageHome> with SingleTickerProviderStateMixin {
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
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: CustomSearchBar(
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
          ScrollableTabs(tabController: _tabController), // Scrollable Tabs **AFTER** CompanyData
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text("Home")),
                Center(child: Text("About")),
                Image(image: NetworkImage(
                  "https://cdn.prod.website-files.com/6548f623e03389ab980fec2a/6752d7396fec014ddeb7d400_672a0de7927a7ff2a130709e_65eb1da89da0e332894adecd_Frame%2525201000006945.webp"
                )),
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
