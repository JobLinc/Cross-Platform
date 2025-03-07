import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/routing/routes.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
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
              child: ChatList(),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar ChatListAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
    elevation: 0,
    automaticallyImplyLeading: false, // Prevents automatic back button
    flexibleSpace: SafeArea(
      // Ensures proper spacing from status bar
      child: Padding(
        padding: EdgeInsets.symmetric(
<<<<<<< HEAD
            horizontal: 10.w, vertical: 5.h), // Adds spacing
=======
            horizontal: 10.w), // Adds spacing
>>>>>>> main
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
                MySearchBar(),
                MoreOptionsButton(),
              ],
            ),
<<<<<<< HEAD
            SizedBox(height: 4.h),
=======
>>>>>>> main
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

//////////////////////////////////////////////////////////////////////////////////

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => IconButton(
            onPressed: () => showMoreOptions(context),
            icon: Icon(
              Icons.more_vert,
              size: 24.sp,
              color: Colors.white,
            )));
  }
}

void showMoreOptions(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.list),
                title: Text("Manage conversations"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text("Set away messages"),
                subtitle: Text("Unlock with Premium"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Manage settings"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      });
}

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search messages",
            prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.black87),
            filled: true,
            fillColor: Colors.white70,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none),
          ),
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }
}

//===========================================Chat Widget================================//

class ChatCard extends StatelessWidget {
  final int? itemIndex;
  final Chat? chat;
  final Function()? press;

  const ChatCard({super.key, this.itemIndex, this.chat, this.press});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    "${chat?.lastSender == 'You' ? 'You' : chat?.userName}: ${chat?.lastMessage.text ?? 'No messages'}",
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
                if (chat!.unreadCount > 0)
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
                    chat?.lastMessage != null ? chat!.lastMessage.time! : '',
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
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Chat> sortedChats = [];

  @override
  void initState() {
    super.initState();
    sortChats();
  }

  void sortChats() {
    setState(() {
      sortedChats = List.from(mockChats); // Copy the list
      sortedChats.sort(
          (a, b) => b.lastMessage.timestamp.compareTo(a.lastMessage.timestamp));
    });
    for (var convo in sortedChats) {
      print("${convo.userName} - ${convo.lastMessage.time}");
    }
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

//===============================Last Message Model(DTO)=========================//

class LastMessage {
  final String senderID;
  final String text;
  final DateTime timestamp;
  String? time;
  final String messageType;

  LastMessage(
      {required this.senderID,
      required this.text,
      required this.timestamp,
      required this.messageType}) {
    time = formatDynamicTime(timestamp);
  }

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      senderID: json['senderID'],
      text: json['text'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['time']),
      messageType: json['messageType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderID': senderID,
      'text': text,
      'time': time,
      'messageType': messageType,
    };
  }

  String formatDynamicTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    Duration difference = now.difference(dateTime);

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      // Show time for today
      return DateFormat.jm().format(dateTime); // Example: "4:59 PM"
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      // Show the short weekday name (Mon, Tue, Wed, etc.)
      return DateFormat.E().format(dateTime);
    } else {
      // Show date in "Jan 10" format
      return DateFormat.MMMd().format(dateTime);
    }
  }
}

//==============================Chat Model(DTO)=================================//

class Chat {
  final String id;
  final String userID;
  final String userName;
  final String? userAvatar;
  final bool isOnline;
  final String lastSender;
  //final List<String> participants;
  final LastMessage lastMessage;
  final int unreadCount;
  final DateTime lastUpdate;

  Chat({
    required this.id,
    required this.userID,
    required this.userName,
    required this.userAvatar,
    required this.isOnline,
    required this.lastSender,
    //required this.participants,
    required this.lastMessage,
    required this.unreadCount,
    required this.lastUpdate,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        id: json['id'],
        userID: json['userID'],
        userName: json['userName'],
        userAvatar: json['userAvatar'],
        isOnline: json['isOnline'],
        lastSender: json['lastSender'],
        //participants:List<String>.from(json['participants']),
        lastMessage: LastMessage.fromJson(json['lastMessage']),
        unreadCount: json['unreadCount'],
        lastUpdate: DateTime.fromMillisecondsSinceEpoch(json['lastUpdated']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'userName': userName,
      'userAvatar': userAvatar,
      'isOnline': isOnline,
      'lastSender': lastSender,
      //'participants':participants,
      'lastMessage': lastMessage.toJson(),
      'unreadCount': unreadCount,
      'lastUpdate': lastUpdate,
    };
  }
}

//==============================Mock Data===========================//

List<Chat> mockChats = [
  Chat(
    id: "conv_001",
    userID: "user2",
    userName: "اخويا الجيار في اللة",
    userAvatar:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQybOhACvhkP99hH4-8UVZyRs429BfgjPBiNA&s",
    lastMessage: LastMessage(
      senderID: "user2",
      text: "انزل يا متدلع",
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(minutes: 10)),
    unreadCount: 2,
    lastSender: "Alice Johnson",
    isOnline: true,
  ),
  Chat(
    id: "conv_002",
    userID: "user3",
    userName: "عم احمد",
    userAvatar:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFhJVW-WJ9ShTQP5iQtnp_jqxbI5VB_Fm3NHgirqN_GXZ2wNDwxgq_s0E6MmL5uwhUj0o&usqp=CAU",
    lastMessage: LastMessage(
      senderID: "user1",
      text: "انت منين ؟",
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(hours: 1)),
    unreadCount: 0,
    lastSender: "You",
    isOnline: false,
  ),
  Chat(
    id: "conv_003",
    userID: "user4",
    userName: "ٍSakr ",
    userAvatar:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFinmoBS3C0r1jV9YOTvO6HFLcrDYYffSN-i7LJs6fAsJ24SV3-lpLKvTpp1WnCJWbUP4&usqp=CAU",
    lastMessage: LastMessage(
      senderID: "user4",
      text: "Ana awel el dof3a",
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      messageType: "file",
    ),
    lastUpdate: DateTime.now().subtract(Duration(hours: 1)),
    unreadCount: 1,
    lastSender: "Charlie Davis",
    isOnline: true,
  ),
  Chat(
    id: "conv_004",
    userID: "user5",
    userName: "Ahmed Hesham",
    userAvatar:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsyI44s5kurKNs7i-ZSj0JlEGcBlCdAYGegg&s",
    lastMessage: LastMessage(
      senderID: "user5",
      text: "اخلص يبني الديدلاين قرب",
      timestamp: DateTime.now().subtract(Duration(days: 0, hours: 3)),
      messageType: "image",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 0, hours: 3)),
    unreadCount: 3,
    lastSender: "Ahmed Hesham",
    isOnline: false,
  ),
  Chat(
    id: "conv_005",
    userID: "user6",
    userName: "Margot Robbie",
    userAvatar:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReFc97WTW0sr9jvt-3n9_01sJdimMpIL9lxpNJytt6kIeSbRHEjNxBQrZ8yHipEMdxyyw&usqp=CAU",
    lastMessage: LastMessage(
      senderID: "user6",
      text: "Night darling ❤️❤️",
      timestamp: DateTime.now().subtract(Duration(days: 0, hours: 4)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 0, hours: 4)),
    unreadCount: 0,
    lastSender: "Emma Wilson",
    isOnline: true,
  ),
  Chat(
    id: "conv_006",
    userID: "user7",
    userName: "رفاعي الدسوقي",
    userAvatar:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMxvaC8-Kta2gPWHD-yo9rX9bg_uCWVIkQRw&s",
    lastMessage: LastMessage(
      senderID: "user1",
      text: "...عارف ياض يا دسوقي الفرق ما بين",
      timestamp: DateTime.now().subtract(Duration(days: 0, hours: 6)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 0, hours: 6)),
    unreadCount: 0,
    lastSender: "You",
    isOnline: false,
  ),
  Chat(
    id: "conv_007",
    userID: "user8",
    userName: "Georgina",
    userAvatar:
        "https://v.wpimg.pl/NWJkMGEyYTYrCTt0agJsI2hRby4sW2J1P0l3ZWpAfW8yXn9_ah8nOy8ZKDcqVyklPxssMDVXPjtlCj0uag9_eC4CPjcpGDd4LwYvIiFWfWR5Wi4hJ0pjYXlaL2pxHC1jZwkvJSZUfWd6D3glIUkvZXMKbzo",
    lastMessage: LastMessage(
      senderID: "user8",
      text: "Are you free later ;)",
      timestamp: DateTime.now().subtract(Duration(days: 0, hours: 8)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 0, hours: 8)),
    unreadCount: 4,
    lastSender: "Grace Martinez",
    isOnline: true,
  ),
  Chat(
    id: "conv_008",
    userID: "user9",
    userName: "Henry Scott",
    userAvatar: null,
    lastMessage: LastMessage(
      senderID: "user1",
      text: "Thanks for the update!",
      timestamp: DateTime.now().subtract(Duration(days: 2, hours: 1)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 2, hours: 1)),
    unreadCount: 0,
    lastSender: "You",
    isOnline: false,
  ),
  Chat(
    id: "conv_009",
    userID: "user10",
    userName: "Isabella Green",
    userAvatar: null,
    lastMessage: LastMessage(
      senderID: "user10",
      text: "I’ll be there in 10 mins.",
      timestamp: DateTime.now().subtract(Duration(days: 3, hours: 4)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 3, hours: 4)),
    unreadCount: 2,
    lastSender: "Isabella Green",
    isOnline: true,
  ),
  Chat(
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
  ),
  Chat(
    id: "conv_011",
    userID: "user12",
    userName: "Karen Lopez",
    userAvatar: null,
    lastMessage: LastMessage(
      senderID: "user12",
      text: "Sure! Sending it now.",
      timestamp: DateTime.now().subtract(Duration(days: 5, hours: 1)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 5, hours: 1)),
    unreadCount: 0,
    lastSender: "You",
    isOnline: true,
  ),
  Chat(
    id: "conv_012",
    userID: "user13",
    userName: "Isabella Blue",
    userAvatar: null,
    lastMessage: LastMessage(
      senderID: "user13",
      text: "I’ll be there in 10 mins.",
      timestamp: DateTime.now().subtract(Duration(days: 6, hours: 4)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 6, hours: 4)),
    unreadCount: 2,
    lastSender: "Isabella Bliue",
    isOnline: true,
  ),
  Chat(
    id: "conv_010",
    userID: "user14",
    userName: "David White",
    userAvatar: null,
    lastMessage: LastMessage(
      senderID: "user14",
      text: "Can you send me the document?",
      timestamp: DateTime.now().subtract(Duration(days: 8, hours: 2)),
      messageType: "file",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 8, hours: 2)),
    unreadCount: 1,
    lastSender: "David White",
    isOnline: false,
  ),
  Chat(
    id: "conv_011",
    userID: "user15",
    userName: "Karen kiro",
    userAvatar: null,
    lastMessage: LastMessage(
      senderID: "user1",
      text: "Sure! Sending it now.",
      timestamp: DateTime.now().subtract(Duration(days: 9, hours: 1)),
      messageType: "text",
    ),
    lastUpdate: DateTime.now().subtract(Duration(days: 9, hours: 1)),
    unreadCount: 0,
    lastSender: "You",
    isOnline: true,
  ),
];



    
    //SafeArea(
  //       child: Scaffold(body: Center(child: Text("Chat List Screen"))));
<<<<<<< HEAD
  // }

=======
  // }
>>>>>>> main
