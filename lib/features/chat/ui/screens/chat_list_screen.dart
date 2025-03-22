import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
//import 'package:joblinc/features/Chat/data/models/chat_model.dart' as ChatModelFake;
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_card.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_list_more_options_button.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late List<Chat> searchedChats;
  bool? isSearching = false;
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatListCubit>().getAllChats();
    searchedChats = List.from(mockChats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: chatListAppBar(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: BlocListener<ChatListCubit, ChatListState>(
                listener: (context, state) {
                  if(state is ChatListSearch){
                    setState(() {
                      searchedChats= state.searchChats;
                    });
                  }
                  else if(state is ChatListFilter){
                    searchedChats = state.filteredChats;
                  }
                },
                child: BlocBuilder<ChatListCubit, ChatListState>(
                  builder: (context, state) {
                    if (state is ChatListLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ChatListEmpty) {
                      return Center(
                          child: Text(
                              "Create Chats with people to see them here "));
                    } else if (state is ChatListLoaded) {
                      return ChatList(key: ValueKey(state.chats.length),
                      chats: state.chats);
                    } else if (state is ChatListSearch) {
                      return ChatList(key: ValueKey(state.searchChats.length),
                      chats: state.searchChats);
                    } else if (state is ChatListFilter) {
                      return ChatList(key: ValueKey(state.filteredChats.length),
                        chats: state.filteredChats);
                    } else {
                      return Center(child: Text("Something went wrong."));
                    }
                    // return ChatList(
                    //   key: ValueKey(searchedChats.length),
                    //   chats: isSearching! ? searchedChats : mockChats,
                    // );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar chatListAppBar(BuildContext context) {
    bool filter = false;
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 68, 68),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,
                        size: 24.sp, color: Colors.white),
                  ),
                  CustomSearchBar(
                      keyName: "chatList_search_textField",
                      text: "search messages",
                      onPress: (){}/*startSearch*/,
                      onTextChange: searchChats /*addSearchedToSearchedList*/,
                      controller: searchTextController),
                  IconButton(
                    key: Key("chatList_filter_iconButton"),
                    onPressed: () {
                      filter = !filter;
                      filterUnreadChats(filter);
                    },
                    icon: Icon(Icons.filter_list, color: Colors.white),
                  ),
                  MoreOptionsButton(),
                ],
              ),
              if (searchTextController.text.isEmpty)
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
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.white70),
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

  // void addSearchedToSearchedList(String searched) {
  //   //print("Search text: $searched");

  //   setState(() {
  //     if (searched.isEmpty) {
  //       searchedChats = List.from(mockChats);
  //     } else {
  //       searchedChats = mockChats
  //           .where((chat) =>
  //               chat.userName.toLowerCase().contains(searched.toLowerCase()))
  //           .toList();
  //     }
  //   });
  //   //print("Filtered chats: ${searchedChats.map((chat) => chat.userName).toList()}");
  // }

  void searchChats(String query) {
    setState(() {
    if (query.isEmpty) {
      isSearching=false;
      searchTextController.clear();
      context.read<ChatListCubit>().getAllChats();
    } else {
      isSearching=true;
      context.read<ChatListCubit>().searchChats(query);
    }
    });
  }

  void filterUnreadChats(bool filter) {
    context.read<ChatListCubit>().filteredChats(filter);
  }

  void addNewChat() {
    final Chat newChat = Chat(
      id: "conv_010",
      userID: "user11",
      userName: "Jack Robinson",
      userAvatar: null,
      lastMessage: LastMessage(
        senderID: "user11",
        text: "Can you send me the document?",
        timestamp: DateTime.now().subtract(Duration(days: 4, hours: 2)),
        messageType: "file",
      ),
      lastUpdate: DateTime.now().subtract(Duration(days: 4, hours: 2)),
      unreadCount: 1,
      lastSender: "Jack Robinson",
      isOnline: false,
    );

    context.read<ChatListCubit>().addNewChat(newChat);
  }

  void startSearch() {
    //ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));
    if (isSearching == false) {
      setState(() {
        isSearching = true;
      });
    }
  }

  // void stopSearching() {
  //   clearSearch();

  //   setState(() {
  //     isSearching = false;
  //     searchedChats = List.from(mockChats);
  //   });
  // }

  // void clearSearch() {
  //   setState(() {
  //     searchTextController.clear();
  //   });
  // }
}
