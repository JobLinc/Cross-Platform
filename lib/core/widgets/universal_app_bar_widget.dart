import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';

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
      // IconButton(
      //   icon: Icon(Icons.message, color: Colors.black),
      //   onPressed: () {
      //     Navigator.pushNamed(context, Routes.chatListScreen);
      //   },
      // ),

      // FutureBuilder<int?>(
      //   future: chatRepo.getTotalUnreadCount(),
      //   builder: (context, snapshot) {
      //     int unread = snapshot.data ?? 0;
      //     return Stack(
      //       children: [
      //         IconButton(
      //           icon: Icon(Icons.message, color: Colors.black),
      //           onPressed: () {
      //             Navigator.pushNamed(context, Routes.chatListScreen);
      //           },
      //         ),
      //         if (unread > 0)
      //           Positioned(
      //             right: 8,
      //             top: 8,
      //             child: Container(
      //               padding: EdgeInsets.all(4),
      //               decoration: BoxDecoration(
      //                 color: Colors.red,
      //                 shape: BoxShape.circle,
      //               ),
      //               constraints: BoxConstraints(
      //                 minWidth: 20,
      //                 minHeight: 20,
      //               ),
      //               child: Center(
      //                 child: Text(
      //                   unread > 99 ? '99+' : unread.toString(),
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 12,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //       ],
      //     );
      //   },
      // ),

      UnreadChatIcon(/*chatRepo: chatRepo*/),
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


class UnreadChatIcon extends StatefulWidget {
  //final ChatRepo chatRepo;
  const UnreadChatIcon({Key? key, /*required this.chatRepo*/}) : super(key: key);

  @override
  State<UnreadChatIcon> createState() => _UnreadChatIconState();
}

class _UnreadChatIconState extends State<UnreadChatIcon> {
  int unread = 0;
  Timer? _timer;
  final chatRepo = getIt<ChatRepo>();

  @override
  void initState() {
    super.initState();
    _fetchUnread();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchUnread());
  }

  Future<void> _fetchUnread() async {
    final count = await /*widget.*/chatRepo.getTotalUnreadCount();
    if (mounted) {
      setState(() {
        unread = count ?? 0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.chatListScreen);
      },
      child: Stack(
        children: [
          Icon(Icons.message, color: Colors.black),
          // IconButton(
          //   icon: Icon(Icons.message, color: Colors.black),
          //   onPressed: () {
          //     Navigator.pushNamed(context, Routes.chatListScreen);
          //   },
          // ),
          if (unread > 0)
            Positioned(
              left: 12.w,
              bottom: 10.h,
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 10.w,
                  minHeight: 10.h,
                ),
                child: Center(
                  child: Text(
                    unread > 99 ? '99+' : unread.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}