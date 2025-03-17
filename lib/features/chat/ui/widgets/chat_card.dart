import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';

class ChatCard extends StatelessWidget {
  final int? itemIndex;
  final Chat? chat;
  final Function()? press;

  const ChatCard({super.key, this.itemIndex, this.chat, this.press});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key:Key("chatList_openChat_card${chat!.id}"),
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Aligns everything centrally
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    chat?.userAvatar ??
                        "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg",
                  ),
                ),
                if (chat?.isOnline ?? false)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat?.userName ?? "Unknown User",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "${chat?.lastSender == 'You' ? 'You' : chat?.userName}: ${chat?.lastMessage!.text ?? 'No messages'}",
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (chat!.unreadCount! > 0)
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
                SizedBox(height: 4),
                SizedBox(
                  width: 60.w,
                  child: Text(
                    chat?.lastMessage != null ? chat!.lastMessage!.time! : '',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
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
  const ChatList({super.key, required this.chats});


  @override
  State<ChatList> createState() => _ChatListState(chats:this.chats);
}

class _ChatListState extends State<ChatList> {
  final List<Chat> chats;
  List<Chat> sortedChats = [];

  _ChatListState({ required this.chats});

  @override
  void initState() {
    super.initState();
    sortChats();
  }


  void sortChats() {
    setState(() {
      sortedChats = List.from(chats); // Copy the list
      sortedChats.sort(
          (a, b) => b.lastMessage!.timestamp!.compareTo(a.lastMessage!.timestamp!));
    });
    // for (var convo in sortedChats) {
    //   print("${convo.userName} - ${convo.lastMessage.time}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: sortedChats.length,
        itemBuilder: (context, index) => ChatCard(
              itemIndex: index,
              chat: sortedChats[index],
              press: () {
                Navigator.pushNamed(context, Routes.chatScreen);
                //print("Tapped on: ${sortedChats[index].userName}");
              },
            ));
  }
}
