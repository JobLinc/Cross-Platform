import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/home/data/models/post_model.dart';
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
          child: Center(
            child:CustomSearchBar(
                      keyName:mainScreens[_selectedIndex].searchKeyName, 
                      text: mainScreens[_selectedIndex].searchText,
                      onPress: mainScreens[_selectedIndex].searchOnPress,
                      onTextChange:  mainScreens[_selectedIndex].searchOnTextChange,
                      controller: mainScreens[_selectedIndex].searchTextController),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, Routes.chatListScreen);
              //Navigator.pushNamed(context, Routes.chatListScreen);  Sameh : who put this here :(
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.crown, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, Routes.premiumScreen);
              //Navigator.pushNamed(context, Routes.chatListScreen);  Sameh : who put this here :(
            },
          ),
        ],
      ),
      body: mainScreens[_selectedIndex].body ,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            thickness: 1,
            height: 0,
          ),
          BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: ColorsManager.darkBurgundy,
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: "My Network"),
              BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Post"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: "Notifications"),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: "Jobs",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
          children: [
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
          ],
        ),
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