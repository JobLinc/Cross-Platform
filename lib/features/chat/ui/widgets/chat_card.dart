import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_avatar.dart';

// chat_card.dart

import 'package:flutter/material.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ChatCard({
    super.key,
    required this.chat,
    required this.onTap,
    required this.onLongPress,
    this.selectionMode = false,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key("chat_${chat.chatId}"),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        child: Row(
          children: [
            if (selectionMode)
              Checkbox(
                  value: selected,
                  onChanged: (_) => onTap(),
                  activeColor: Colors.red)
            //CircleAvatar(backgroundImage: NetworkImage(chat.chatPicture)),
            else
              chat.chatPicture != null
                  ? buildChatAvatar(chat.chatPicture!)
                  : buildChatAvatar(null),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chat.chatName,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.h),
                  chat.isTyping == true
                      ? Text("Typing...",
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.green))
                      : Text("${chat.senderName}: ${chat.lastMessage ?? ''}",
                          overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if ((chat!.unreadCount! > 0) && (chat.isRead == false))
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 243, 33, 33),
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${chat!.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (!chat.isRead && !(chat.unreadCount! > 0))
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: BoxConstraints(  minWidth: 18, minHeight: 18,),
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      alignment: Alignment.center,
                    ),
                  ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: 60.w,
                  child: Text(chat.time ?? '',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            // if (chat.unreadCount! > 0)
            //   Container(
            //     padding: EdgeInsets.all(6.r),
            //     decoration:
            //         BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            //     child: Text('${chat.unreadCount}',
            //         style: TextStyle(color: Colors.white, fontSize: 12.sp)),
            //   ),
            // if (!chat.isRead && !(chat.unreadCount! > 0))
            //   Container(
            //     padding: EdgeInsets.all(6.r),
            //     decoration:
            //         BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            //     child: Container(
            //       padding: EdgeInsets.all(3.r),
            //       decoration: BoxDecoration(
            //           color: Colors.white, shape: BoxShape.circle),
            //     ),
            //   ),
            // SizedBox(width: 8.w),
            // Text(chat.time ?? '',
            //     style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }
}

// class ChatCard extends StatelessWidget {
//   //final int? itemIndex;
//   final Chat? chat;
//   final VoidCallback onTap;
//   final VoidCallback onLongPress;
//   final bool selectionMode;
//   final bool selected;

//   const ChatCard({
//     super.key,
//     //required this.itemIndex,
//     required this.chat,
//     required this.onTap,
//     required this.onLongPress,
//     this.selectionMode = false,
//     this.selected = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       key: Key("chatList_openChat_card${chat!.chatId}"),
//       onTap: onTap,
//       onLongPress: onLongPress,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment:
//               CrossAxisAlignment.center, // Aligns everything centrally
//           children: [
//             if (selectionMode) ...[
//               Checkbox(
//                 value: selected,
//                 activeColor: Colors.red,
//                 onChanged: (_) => onTap(),
//               ),
//             ] else ...[
//               Stack(
//                 children: [
//                   buildChatAvatar(chat!.chatPicture),
//                   if (true)
//                     Positioned(
//                       bottom: 2,
//                       right: 2,
//                       child: Container(
//                         width: 10,
//                         height: 10,
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 2),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//             SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     chat?.chatName ?? "Unknown User",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 3),
//                   chat?.isTyping == true
//                       ? Text(
//                           "Typing...",
//                           style: TextStyle(
//                               color: Colors.green, fontStyle: FontStyle.italic),
//                         )
//                       : Text(
//                           "${chat?.senderName}:  ${chat?.lastMessage ?? 'No messages'}",
//                           style: TextStyle(color: Colors.grey),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                 ],
//               ),
//             ),
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (chat!.unreadCount! > 0)
//                   Container(
//                     padding: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Color.fromARGB(255, 243, 33, 33),
//                       shape: BoxShape.circle,
//                     ),
//                     constraints: BoxConstraints(
//                       minWidth: 18,
//                       minHeight: 18,
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       '${chat!.unreadCount}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 SizedBox(height: 4),
//                 SizedBox(
//                   width: 60.w,
//                   child: Text(
//                     chat?.lastMessage != null ? chat!.time : '',
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ChatList extends StatefulWidget {
  final List<Chat> chats;
  final bool selectionMode;
  final Set<String>? selectedIds;
  const ChatList({
    super.key,
    required this.chats,
    this.selectionMode = false,
    this.selectedIds,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Chat> sortedChats = [];
  //final List<Chat> chats;

  @override
  void initState() {
    super.initState();
    sortChats();
  }

  void sortChats() {
    setState(() {
      sortedChats = List.from(widget.chats);
      sortedChats.sort((a, b) => b.sentDate!.compareTo(a.sentDate!));
    });
    // for (var convo in sortedChats) {
    //   print("${convo.userName} - ${convo.lastMessage.time}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: sortedChats.length,
        itemBuilder: (_, index) => ChatCard(
              //itemIndex: index,
              key: ValueKey(sortedChats[index].chatId),
              chat: sortedChats[index],
              selectionMode: widget.selectionMode,
              selected:
                  widget.selectedIds?.contains(sortedChats[index].chatId) ??
                      false,
              onTap: () async {
                if (widget.selectionMode) {
                  context
                      .read<ChatListCubit>()
                      .toggleSelection(sortedChats[index].chatId);
                } else {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ChatListCubit>(),
                        child: ChatScreen(chatId: sortedChats[index].chatId),
                      ),
                    ),
                  );
                  context.read<ChatListCubit>().getAllChats();
                }
              },
              onLongPress: () {
                context
                    .read<ChatListCubit>()
                    .toggleSelection(sortedChats[index].chatId);
              },
            ));
  }
}

              // {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => BlocProvider<ChatListCubit>(
              //               create: (context) => getIt<ChatListCubit>(),
              //               child: ChatScreen(chat: sortedChats[index]))));
              // },              // if (chat.unreadCount > 0)
              //   Positioned(
              //     bottom: 2,
              //     right: 2,
              //     child: Container(
              //       width: 10.r,
              //       height: 10.r,
              //       decoration: BoxDecoration(
              //         color: Colors.green,
              //         shape: BoxShape.circle,
              //         border: Border.all(color: Colors.white, width: 2.w),
              //       ),
              //     ),
              //   ),