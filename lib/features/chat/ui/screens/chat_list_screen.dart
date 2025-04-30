import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_card.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_list_more_options_button.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat>? chats;
  bool? isSearching = false;
  bool filter = false;
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatListCubit>().getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        return Scaffold(
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(100.h),
          //   child: chatListAppBar(context),
          //),
          appBar: chatListAppBar(context),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Expanded(child: buildBody(state)),
              ],
            ),
          ),
          bottomNavigationBar: state is ChatListSelected
              ? buildSelectionActions(context, state)
              : null,
        );
      },
    );
  }

  // AppBar chatListAppBar(BuildContext context) {
  //   final state = context.watch<ChatListCubit>().state;
  //   if (state is ChatListSelected) {
  //     // Selection mode AppBar
  //     return AppBar(
  //       backgroundColor: Colors.red,
  //       leading: IconButton(
  //         icon: Icon(Icons.close, size: 24.sp),
  //         onPressed: () => context.read<ChatListCubit>().clearSelection(),
  //       ),
  //       title: Text(
  //         "${state.selectedIds.length} selected",
  //         style: TextStyle(fontSize: 18.sp),
  //       ),
  //     );
  //   }
  //   return AppBar(
  //     backgroundColor: const Color.fromARGB(255, 255, 68, 68),
  //     elevation: 0,
  //     automaticallyImplyLeading: false,
  //     toolbarHeight: kToolbarHeight + 40.h,
  //     flexibleSpace: SafeArea(
  //       child: SizedBox(
  //         height: kToolbarHeight + 40.h,
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 10.w),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Row(
  //                 children: [
  //                   IconButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     icon: Icon(Icons.arrow_back,
  //                         size: 24.sp, color: Colors.white),
  //                   ),
  //                   Expanded(
  //                     child: CustomSearchBar(
  //                         keyName: "chatList_search_textField",
  //                         text: "search messages",
  //                         onPress: () {} /*startSearch*/,
  //                         onTextChange: searchChats /*addSearchedToSearchedList*/,
  //                         controller: searchTextController),
  //                   ),
  //                   IconButton(
  //                     key: Key("chatList_filter_iconButton"),
  //                     onPressed: () {
  //                       setState(() {
  //                         filter = !filter;
  //                       });
  //                       context.read<ChatListCubit>().filteredChats(filter);
  //                       //filterUnreadChats(filter);
  //                     },
  //                     icon: Icon(Icons.filter_list, color: Colors.white),
  //                   ),
  //                   MoreOptionsButton(),
  //                 ],
  //               ),
  //               if (searchTextController.text.isEmpty)
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "Recent Conversations",
  //                       style: TextStyle(
  //                           fontSize: 14.sp,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.white),
  //                     ),
  //                     TextButton(
  //                       onPressed: () {},
  //                       child: Text(
  //                         "View All",
  //                         style:
  //                             TextStyle(fontSize: 12.sp, color: Colors.white70),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  PreferredSizeWidget chatListAppBar(BuildContext context) {
  final state = context.watch<ChatListCubit>().state;

  // Selection mode AppBar
  if (state is ChatListSelected) {
    return AppBar(
      backgroundColor: ColorsManager.crimsonRed,
      leading: IconButton(
        icon: Icon(Icons.close, size: 24.sp),
        onPressed: () => context.read<ChatListCubit>().clearSelection(),
      ),
      title: Text(
        "${state.selectedIds.length} selected",
        style: TextStyle(fontSize: 18.sp),
      ),
    );
  }

  final bool showRecentLabel = searchTextController.text.isEmpty;
  final double extraHeight = showRecentLabel ? 45.h : 0;

  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight + extraHeight + 20.h), // Adjusted height
    child: AppBar(
      backgroundColor: ColorsManager.crimsonRed,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.white),
                  ),
                  Expanded(
                    child: CustomSearchBar(
                      keyName: "chatList_search_textField",
                      text: "search messages",
                      onPress: () {},
                      onTextChange: searchChats,
                      controller: searchTextController,
                    ),
                  ),
                  IconButton(
                    key: const Key("chatList_filter_iconButton"),
                    onPressed: () {
                      setState(() {
                        filter = !filter;
                      });
                      context.read<ChatListCubit>().filteredChats(filter);
                    },
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                  ),
                  const MoreOptionsButton(),
                ],
              ),
              if (showRecentLabel)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Conversations",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                ),
            ],
          ),
        ),
      ),
    ),
  );
}


  Widget buildBody(ChatListState state) {
    if (state is ChatListLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (state is ChatListEmpty) {
      return Center(child: Text('No conversations yet'));
    }
    if (state is ChatListSelected) {
      chats = state.chats;
      return ChatList(
        chats: state.chats,
        selectionMode: true,
        selectedIds: state.selectedIds,
      );
    }
    if (state is ChatListLoaded) {
      chats = state.chats;
      return ChatList(chats: state.chats);
    }
    if (state is ChatListSearch) {
      return ChatList(
          key: ValueKey(state.searchChats.length), chats: state.searchChats);
    }
    if (state is ChatListFilter) {
      return ChatList(
          key: ValueKey(state.filteredChats.length),
          chats: state.filteredChats);
    }
    if (chats != null) {
      return ChatList(chats: chats!);
    }
    return Center(child: Text('Something went wrong'));
  }

  Widget buildSelectionActions(BuildContext context, ChatListSelected state) {
    final anyUnread = state.chats
        .where((c) => state.selectedIds.contains(c.chatId))
        .any((c) => c.unreadCount > 0);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              context.read<ChatListCubit>().markReadOrUnreadSelected(anyUnread);
            },
            child: Text(anyUnread ? 'Mark read' : 'Mark unread',
                style: TextStyle(color: Colors.red, fontSize: 16.sp)),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatListCubit>().deleteSelected();
            },
            child: Text('Delete',
                style: TextStyle(color: Colors.red, fontSize: 16.sp)),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatListCubit>().archiveSelected();
            },
            child: Text('Archive',
                style: TextStyle(color: Colors.red, fontSize: 16.sp)),
          ),
        ],
      ),
    );
  }

  void searchChats(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        searchTextController.clear();
        context.read<ChatListCubit>().getAllChats();
      } else {
        isSearching = true;
        context.read<ChatListCubit>().searchChats(query);
      }
    });
  }
}
  // void filterUnreadChats(bool filter) {
  //   context.read<ChatListCubit>().filteredChats(filter);
  // }

  // void addNewChat() {
  //   final Chat newChat = Chat(
  //     id: "conv_010",
  //     userID: "user11",
  //     userName: "Jack Robinson",
  //     userAvatar: null,
  //     lastMessage: LastMessage(
  //       senderID: "user11",
  //       text: "Can you send me the document?",
  //       timestamp: DateTime.now().subtract(Duration(days: 4, hours: 2)),
  //       messageType: "file",
  //     ),
  //     lastUpdate: DateTime.now().subtract(Duration(days: 4, hours: 2)),
  //     unreadCount: 1,
  //     lastSender: "Jack Robinson",
  //     isOnline: false,
  //   );

  //   context.read<ChatListCubit>().addNewChat(newChat);
  // }

  // void startSearch() {
  //   //ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearching));
  //   if (isSearching == false) {
  //     setState(() {
  //       isSearching = true;
  //     });
  //   }
  // }

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

// if (state is ChatListLoading) 
//                            Center(child: CircularProgressIndicator())
//                          else if (state is ChatListEmpty) 
//                            Center(
//                               child: Text(
//                                   "Create Chats with people to see them here "))
//                          else if (state is ChatListLoaded) 
//                            ChatList(
//                               key: ValueKey(state.chats.length),
//                               chats: state.chats)
//                          else if (state is ChatListSearch) 
//                          ChatList(
//                               key: ValueKey(state.searchChats.length),
//                               chats: state.searchChats)
//                         else if (state is ChatListFilter) 
//                           ChatList(
//                               key: ValueKey(state.filteredChats.length),
//                               chats: state.filteredChats)
//                          else 
//                            Center(child: Text("Something went wrong."))
              //   child: BlocListener<ChatListCubit, ChatListState>(
                //     listener: (context, state) {
                //       if (state is ChatListSearch) {
                //         setState(() {
                //           searchedChats = state.searchChats;
                //         });
                //       } else if (state is ChatListFilter) {
                //         searchedChats = state.filteredChats;
                //       }
                //     },
                // child: BlocBuilder<ChatListCubit, ChatListState>(
                //   builder: (context, state) {
                //  child:  if (state is ChatListLoading) {
                //     return Center(child: CircularProgressIndicator());
                //   } else if (state is ChatListEmpty) {
                //     return Center(
                //         child: Text(
                //             "Create Chats with people to see them here "));
                //   } else if (state is ChatListLoaded) {
                //     return ChatList(
                //         key: ValueKey(state.chats.length),
                //         chats: state.chats);
                //   } else if (state is ChatListSearch) {
                //     return ChatList(
                //         key: ValueKey(state.searchChats.length),
                //         chats: state.searchChats);
                //   } else if (state is ChatListFilter) {
                //     return ChatList(
                //         key: ValueKey(state.filteredChats.length),
                //         chats: state.filteredChats);
                //   } else {
                //     return Center(child: Text("Something went wrong."));
                //   }
                //   // return ChatList(
                //   //   key: ValueKey(searchedChats.length),
                //   //   chats: isSearching! ? searchedChats : mockChats,
                //   // );
                // },