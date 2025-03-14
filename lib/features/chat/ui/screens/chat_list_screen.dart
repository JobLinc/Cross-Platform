import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_card.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_list_more_options_button.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late List<Chat> searchedChats;
  bool? isSearching= false;
  final searchTextController=TextEditingController();
  @override

  void initState() {
    super.initState();
    searchedChats = List.from(mockChats);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: ChatListAppBar(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: ChatList(
                key: ValueKey(searchedChats.length),
                chats:isSearching! ? searchedChats : mockChats,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar ChatListAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
    elevation: 0,
    automaticallyImplyLeading: false, // Prevents automatic back button
    flexibleSpace: SafeArea(
      // Ensures proper spacing from status bar
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w), // Adds spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon:
                      Icon(Icons.arrow_back, size: 24.sp, color: Colors.white),
                ),
                CustomSearchBar(
                  text: "search messages",
                  onPress:startSearch,
                   onTextChange:addSearchedToSearchedList,
                   controller: searchTextController
                   ),
                MoreOptionsButton(),
              ],
            ),
            if(searchTextController.text.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Conversations",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View All",
                    style: TextStyle(fontSize: 12.sp, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  void addSearchedToSearchedList(String searched){
    //print("Search text: $searched"); 

    setState((){
      if (searched.isEmpty) {
        searchedChats = List.from(mockChats); 
      } else {
        searchedChats=mockChats.where((chat)=>chat.userName.toLowerCase().contains(searched.toLowerCase())).toList();    
      }
    });
    print("Filtered chats: ${searchedChats.map((chat) => chat.userName).toList()}"); 

  }
  void startSearch() {
    //ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));
    if (isSearching == false){
      setState(() {
        isSearching = true;
      });
    }
  }

  void stopSearching() {
    clearSearch();

    setState(() {
      isSearching = false;
      searchedChats = List.from(mockChats);
    });
  }

  void clearSearch() {
    setState(() {
      searchTextController.clear();
    });
  }


}







