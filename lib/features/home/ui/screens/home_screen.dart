import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/home/data/models/post_model.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/home/ui/widgets/post_widget.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {


    List<HomeScreenInput> mainScreens=[
      HomeScreenInput(
        searchKeyName: "",
        searchText: "search",
        searchOnPress: emptyFunction,
        searchOnTextChange: emptyFunction,
        searchTextController: SearchController(),
        body:HomeScreenBody()
      ),
        HomeScreenInput(
        searchKeyName: "",
        searchText: "search",
        searchOnPress: emptyFunction,
        searchOnTextChange: emptyFunction,
        searchTextController: SearchController(),
        body:HomeScreenBody()
      ),
        HomeScreenInput(
        searchKeyName: "",
        searchText: "search",
        searchOnPress: emptyFunction,
        searchOnTextChange: emptyFunction,
        searchTextController: SearchController(),
        body:HomeScreenBody()
      ),
        HomeScreenInput(
        searchKeyName: "",
        searchText: "search",
        searchOnPress: emptyFunction,
        searchOnTextChange: emptyFunction,
        searchTextController: SearchController(),
        body:HomeScreenBody()
      ),
        HomeScreenInput(
        searchKeyName: "jobList_search_textField",
        searchText: "search jobs",
        searchOnPress:()=>goToJobSearch(context),
        searchOnTextChange: emptyFunction,
        searchTextController: SearchController(),
        body:JobListScreen()
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 1,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Semantics(
            container: true,
            label: 'home_topBar_container',
            child: Center(
              child: Semantics(
                label: 'home_topBar_search',
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          Semantics(
            label: 'home_topBar_chatButton',
            child: IconButton(
              icon: Icon(Icons.message, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, Routes.chatListScreen);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Semantics(
          container: true,
          label: 'home_body_postList',
          child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) => Post(data: mockData)),
        ),
      ),
      bottomNavigationBar: UniversalBottomBar(),
    );
  }
}


class HomeScreenInput{
  late String searchKeyName;
  late String searchText;
  late VoidCallback searchOnPress;
  late Function searchOnTextChange;
  late TextEditingController searchTextController;
  late Widget body;

    HomeScreenInput({
      required this.searchKeyName,
      required this.searchText,
      required this.searchOnPress,
      required this.searchOnTextChange,
      required this.searchTextController,
      required this.body
    });
}



void emptyFunction(){}
void goToJobSearch(BuildContext context){
  Navigator.pushNamed(context,Routes.jobSearchScreen);
  }