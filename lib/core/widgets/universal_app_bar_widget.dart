import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';

AppBar universalAppBar(
    {required BuildContext context,
    required int selectedIndex,
    VoidCallback? searchBarFunction}) {
  List<UniversalAppBarInput> mainScreens = [
    UniversalAppBarInput(
      searchKeyName: "",
      searchText: "search",
      searchOnPress: emptyFunction,
      searchOnTextChange: emptyFunction,
      searchTextController: SearchController(),
    ),
    UniversalAppBarInput(
      searchKeyName: "",
      searchText: "search network",
      searchOnPress: emptyFunction,
      searchOnTextChange: emptyFunction,
      searchTextController: SearchController(),
    ),
    UniversalAppBarInput(
      searchKeyName: "",
      searchText: "search posts",
      searchOnPress: emptyFunction,
      searchOnTextChange: emptyFunction,
      searchTextController: SearchController(),
    ),
    UniversalAppBarInput(
      searchKeyName: "",
      searchText: "search notifiactions",
      searchOnPress: emptyFunction,
      searchOnTextChange: emptyFunction,
      searchTextController: SearchController(),
    ),
    UniversalAppBarInput(
      searchKeyName: "jobList_search_textField",
      searchText: "search jobs",
      searchOnPress: searchBarFunction ?? emptyFunction,
      searchOnTextChange: emptyFunction,
      searchTextController: SearchController(),
    ),
  ];
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.surface,
    elevation: 0,
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
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.02),
                      keyName: mainScreens[selectedIndex].searchKeyName,
                      text: mainScreens[selectedIndex].searchText,
                      onPress: mainScreens[selectedIndex].searchOnPress,
                      onTextChange:
                          mainScreens[selectedIndex].searchOnTextChange,
                      controller:
                          mainScreens[selectedIndex].searchTextController),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.message, color: Colors.black),
        onPressed: () {
          Navigator.pushNamed(context, Routes.chatListScreen);
        },
      ),
      IconButton(
        icon: Icon(FontAwesomeIcons.crown, color: Colors.black),
        onPressed: () {
          Navigator.pushNamed(context, Routes.premiumScreen);
        },
      ),
    ],
  );
}

void emptyFunction() {}
// void goToJobSearch(BuildContext context){
//   //Navigator.pushNamed(context,Routes.jobSearchScreen);
//   Navigator.of(context).pushNamed(Routes.jobSearchScreen);
//   }

class UniversalAppBarInput {
  late String searchKeyName;
  late String searchText;
  late VoidCallback searchOnPress;
  late Function searchOnTextChange;
  late TextEditingController searchTextController;

  UniversalAppBarInput({
    required this.searchKeyName,
    required this.searchText,
    required this.searchOnPress,
    required this.searchOnTextChange,
    required this.searchTextController,
  });
}
