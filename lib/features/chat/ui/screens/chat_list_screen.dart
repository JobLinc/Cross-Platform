// chat_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/data/services/chat_socket_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_card.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat>? chats;
  bool filter = false;
  final searchTextController = TextEditingController();

  final socketService = ChatSocketService.instance;
  String? userId, accessToken;
  bool isSocketInitialized = false;

  @override
  void initState() {
    super.initState();
    // load existing chats
    context.read<ChatListCubit>().getAllChats();
    _initSocket();
  }

  Future<void> _initSocket() async {
    final auth = getIt<AuthService>();
    userId = await auth.getUserId();
    accessToken = await auth.getAccessToken();
    if (userId == null || accessToken == null) return;

    // initialize once
    final connected = await socketService.initialize(
      userId: userId!,
      accessToken: accessToken!,
    );
    if (!connected) return;

    setState(() => isSocketInitialized = true);

    // subscribe via callbacks
    socketService.onListTyping = (chatId) {
      context.read<ChatListCubit>().setTyping(chatId, true);
    };
    socketService.onListStopTyping = (chatId) {
      context.read<ChatListCubit>().setTyping(chatId, false);
    };
    socketService.onCardUpdate = (data) {
      context.read<ChatListCubit>().updateChatCard(data);
    };
  }

  @override
  void dispose() {
    if (isSocketInitialized) {
      socketService.clearEventHandlers();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context,),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
          bottomNavigationBar: state is ChatListSelected
              ? _buildSelectionActions(context, state)
              : null,
        );
      },
    );
  }


   AppBar _buildAppBar(BuildContext context) {
    final state = context.watch<ChatListCubit>().state;
    if (state is ChatListSelected) {
      // Selection mode AppBar
      return AppBar(
        backgroundColor: Colors.red,
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
    return AppBar(
      backgroundColor: ColorsManager.getPrimaryColor(context),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight + 40.h,
      flexibleSpace: SafeArea(
        child: SizedBox(
          height: kToolbarHeight + 40.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    Expanded(
                      child: CustomSearchBar(
                          keyName: "chatList_search_textField",
                          text: "search messages",
                          onPress: () {} /*startSearch*/,
                          onTextChange: _searchChats /*addSearchedToSearchedList*/,
                          controller: searchTextController),
                    ),
                    IconButton(
                      key: Key("chatList_filter_iconButton"),
                      onPressed: () {
                        setState(() {
                          filter = !filter;
                        });
                        context.read<ChatListCubit>().filteredChats(filter);
                        //filterUnreadChats(filter);
                      },
                      icon: Icon(Icons.filter_list, color: Colors.white),
                    ),
                    //MoreOptionsButton(),
                  ],
                ),
                // if (searchTextController.text.isEmpty)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "Recent Conversations",
                //         style: TextStyle(
                //             fontSize: 14.sp,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white),
                //       ),
                //       TextButton(
                //         onPressed: () {},
                //         child: Text(
                //           "View All",
                //           style:
                //               TextStyle(fontSize: 12.sp, color: Colors.white70),
                //         ),
                //       ),
                //     ],
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
   }

  // PreferredSizeWidget _buildAppBar(BuildContext c, ChatListState state) {
  //   if (state is ChatListSelected) {
  //     return AppBar(
  //       backgroundColor: Colors.red,
  //       leading: IconButton(
  //         icon: Icon(Icons.close, size: 24.sp),
  //         onPressed: () => context.read<ChatListCubit>().clearSelection(),
  //       ),
  //       title: Text("${state.selectedIds.length} selected", style: TextStyle(fontSize: 18.sp)),
  //     );
  //   }

  //   return AppBar(
  //     backgroundColor: Colors.red,
  //     elevation: 0,
  //     automaticallyImplyLeading: false,
  //     flexibleSpace: SafeArea(
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
  //         child: Row(
  //           children: [
  //             IconButton(
  //               onPressed: () => Navigator.pop(context),
  //               icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.white),
  //             ),
  //             Expanded(
  //               child: TextField(
  //                 controller: searchTextController,
  //                 decoration: InputDecoration(
  //                   hintText: "Search messages",
  //                   fillColor: Colors.white,
  //                   filled: true,
  //                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //                 ),
  //                 onChanged: _searchChats,
  //               ),
  //             ),
  //             IconButton(
  //               onPressed: () {
  //                 setState(() => filter = !filter);
  //                 context.read<ChatListCubit>().filteredChats(filter);
  //               },
  //               icon: Icon(Icons.filter_list, color: Colors.white),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBody(ChatListState state) {
    if (state is ChatListLoading) return Center(child: CircularProgressIndicator());
    if (state is ChatListEmpty)   return Center(child: Text('No conversations yet'));

    final list = (state is ChatListLoaded)
        ? state.chats
        : (state is ChatListSearch) ? state.searchChats
        : (state is ChatListFilter) ? state.filteredChats
        : (state is ChatListSelected) ? state.chats
        : chats;

    if (list == null || list.isEmpty) return Center(child: Text('No conversations'));

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final c = list[i];
        return ChatCard(
          key: ValueKey(c.chatId), 
          chat: c,
          selectionMode: state is ChatListSelected,
          selected: state is ChatListSelected && state.selectedIds.contains(c.chatId),
          onTap: () async {
            if (state is ChatListSelected) {
              context.read<ChatListCubit>().toggleSelection(c.chatId);
            } else {
              await Navigator.pushNamed(context, Routes.chatScreen, arguments: c.chatId);
              context.read<ChatListCubit>().reloadChats(); 
            }
          },
          onLongPress: () => context.read<ChatListCubit>().toggleSelection(c.chatId),
        );
      },
    );
  }

  Widget _buildSelectionActions(BuildContext ctx, ChatListSelected s) {
    final anyUnread = s.chats.where((c) => s.selectedIds.contains(c.chatId)).any((c) => ((c.unreadCount! > 0) && (c.isRead==false)) || (c.isRead == false));
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => context.read<ChatListCubit>().markReadOrUnreadSelected(anyUnread),
            child: Text(anyUnread ? 'Mark read' : 'Mark unread', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => context.read<ChatListCubit>().deleteSelected(),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => context.read<ChatListCubit>().archiveSelected(),
            child: Text('Archive', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _searchChats(String q) {
    if (q.isEmpty) {
      context.read<ChatListCubit>().getAllChats();
    } else {
      context.read<ChatListCubit>().searchChats(q);
    }
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:joblinc/core/di/dependency_injection.dart';
// import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
// import 'package:joblinc/core/theming/colors.dart';
// import 'package:joblinc/core/widgets/custom_search_bar.dart';
// import 'package:joblinc/features/chat/data/models/chat_model.dart';
// import 'package:joblinc/features/chat/data/services/chat_socket_service.dart';
// import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
// import 'package:joblinc/features/chat/ui/widgets/chat_card.dart';
// import 'package:joblinc/features/chat/ui/widgets/chat_list_more_options_button.dart';

// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({super.key});

//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   List<Chat>? chats;
//   bool? isSearching = false;
//   bool filter = false;
//   final searchTextController = TextEditingController();
//    late ChatSocketService socketService;
//   String? userId;
//   String? accessToken;
//   bool isSocketInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<ChatListCubit>().getAllChats();
//     _initSocket();
//   }



// Future<void> _initSocket() async {

//    final auth = getIt<AuthService>();
//   userId = await auth.getUserId();
//   accessToken = await auth.getAccessToken();
//   socketService = ChatSocketService(userId!, accessToken!);
//   bool connected = await socketService.initialize();
//   if (connected) {
//     setState(() => isSocketInitialized = true);
//     _setupSocketListeners();
//   }
// }

// void _setupSocketListeners() {
//   final socket = socketService.socket;


//   socket.on('cardUpdate', (data) {
//     // data should contain updated chat info
//     context.read<ChatListCubit>().updateChatCard(data);
//   });
// }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChatListCubit, ChatListState>(
//       builder: (context, state) {
//         return Scaffold(
//           // appBar: PreferredSize(
//           //   preferredSize: Size.fromHeight(100.h),
//           //   child: chatListAppBar(context),
//           //),
//           appBar: chatListAppBar(context),
//           body: SafeArea(
//             child: Column(
//               children: [
//                 SizedBox(height: 10.h),
//                 Expanded(child: buildBody(state)),
//               ],
//             ),
//           ),
//           bottomNavigationBar: state is ChatListSelected
//               ? buildSelectionActions(context, state)
//               : null,
//         );
//       },
//     );
//   }

 

//   PreferredSizeWidget chatListAppBar(BuildContext context) {
//   final state = context.watch<ChatListCubit>().state;

//   // Selection mode AppBar
//   if (state is ChatListSelected) {
//     return AppBar(
//       backgroundColor: ColorsManager.crimsonRed,
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
  
//  return AppBar(
//       backgroundColor: ColorsManager.crimsonRed,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       flexibleSpace: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(Icons.arrow_back, size: 24.sp, color: Colors.white),
//                   ),
//                   Expanded(
//                     child: CustomSearchBar(
//                       keyName: "chatList_search_textField",
//                       text: "search messages",
//                       onPress: () {},
//                       onTextChange: searchChats,
//                       controller: searchTextController,
//                     ),
//                   ),
//                   IconButton(
//                     key: const Key("chatList_filter_iconButton"),
//                     onPressed: () {
//                       setState(() {
//                         filter = !filter;
//                       });
//                       context.read<ChatListCubit>().filteredChats(filter);
//                     },
//                     icon: const Icon(Icons.filter_list, color: Colors.white),
//                   ),
//                   const MoreOptionsButton(),
//                 ],
//               ),
              
//             ],
//           ),
//         ),
//       ),
//     );
//   //);
// }


//   Widget buildBody(ChatListState state) {
//     if (state is ChatListLoading) {
//       return Center(child: CircularProgressIndicator());
//     }
//     if (state is ChatListEmpty) {
//       return Center(child: Text('No conversations yet'));
//     }
//     if (state is ChatListSelected) {
//       chats = state.chats;
//       return ChatList(
//         chats: state.chats,
//         selectionMode: true,
//         selectedIds: state.selectedIds,
//       );
//     }
//     if (state is ChatListLoaded) {
//       chats = state.chats;
//       return ChatList(chats: state.chats);
//     }
//     if (state is ChatListSearch) {
//       return ChatList(
//           key: ValueKey(state.searchChats.length), chats: state.searchChats);
//     }
//     if (state is ChatListFilter) {
//       return ChatList(
//           key: ValueKey(state.filteredChats.length),
//           chats: state.filteredChats);
//     }
//     if (chats != null) {
//       return ChatList(chats: chats!);
//     }
//     return Center(child: Text('Something went wrong'));
//   }

//   Widget buildSelectionActions(BuildContext context, ChatListSelected state) {
//     final anyUnread = state.chats
//         .where((c) => state.selectedIds.contains(c.chatId))
//         .any((c) => c.unreadCount! > 0);
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: Colors.grey.shade300)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           TextButton(
//             onPressed: () {
//               context.read<ChatListCubit>().markReadOrUnreadSelected(anyUnread);
//             },
//             child: Text(anyUnread ? 'Mark read' : 'Mark unread',
//                 style: TextStyle(color: Colors.red, fontSize: 16.sp)),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<ChatListCubit>().deleteSelected();
//             },
//             child: Text('Delete',
//                 style: TextStyle(color: Colors.red, fontSize: 16.sp)),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<ChatListCubit>().archiveSelected();
//             },
//             child: Text('Archive',
//                 style: TextStyle(color: Colors.red, fontSize: 16.sp)),
//           ),
//         ],
//       ),
//     );
//   }

//   void searchChats(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         isSearching = false;
//         searchTextController.clear();
//         context.read<ChatListCubit>().getAllChats();
//       } else {
//         isSearching = true;
//         context.read<ChatListCubit>().searchChats(query);
//       }
//     });
//   }
// }

// Ge  // // Listen for typing events
  // socket.on('messageTyping', (data) {
  //   final chatId = data['chatId'];
  //   context.read<ChatListCubit>().setTyping(chatId, true);
  // });

  // socket.on('stopTyping', (data) {
  //   final chatId = data['chatId'];
  //   context.read<ChatListCubit>().setTyping(chatId, false);
  // });

  // Listen for card update events (e.g., last message, unread count)t userId and accessToken (use your DI/auth logic)
  // Example:

    // For demo, use dummy values or fetch as above
  // userId = "your_user_id";
  // accessToken = "your_access_token";
  //final bool showRecentLabel = searchTextController.text.isEmpty;
  //final double extraHeight = showRecentLabel ? 45.h : 0;

  // return PreferredSize(
  //   //preferredSize: Size.fromHeight(kToolbarHeight + extraHeight ), // Adjusted height
  //   child: 
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
                // }, // AppBar chatListAppBar(BuildContext context) {
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
  // }// if (showRecentLabel)
              //   Padding(
              //     padding: EdgeInsets.only(top: 4.h),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           "Recent Conversations",
              //           style: TextStyle(
              //             fontSize: 14.sp,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white,
              //           ),
              //         ),
              //         TextButton(
              //           onPressed: () {},
              //           child: Text(
              //             "View All",
              //             style: TextStyle(fontSize: 12.sp, color: Colors.white70),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),