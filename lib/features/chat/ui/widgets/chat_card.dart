import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_avatar.dart';

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
          ],
        ),
      ),
    );
  }
}

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
