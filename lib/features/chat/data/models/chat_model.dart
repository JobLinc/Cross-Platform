import 'package:intl/intl.dart';

class Chat {
  final String chatId;
  final String chatName;
  final List<String>? chatPicture;
  final String lastMessage;
  final DateTime sentDate; // Unix timestamp in seconds
  final int unreadCount;
  final bool isRead;
  late String time;

  Chat({
    required this.chatId,
    required this.chatName,
    required this.chatPicture,
    required this.lastMessage,
    required this.sentDate,
    required this.unreadCount,
    required this.isRead,
  }){time = formatDynamicTime(sentDate);}

  factory Chat.fromJson(Map<String, dynamic> json) {
     // the placeholder path to look for
  const placeholder = '/uploads/placeholder/profile.png';
  // the URL you want to use instead
  const defaultAvatarUrl = 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg';

  // grab the raw list (might be null)
  final rawPics = json['chatPicture'] as List<dynamic>?;

  // build a clean List<String>, replacing placeholder where needed
  final pics = (rawPics ?? [])
      .map((e) {
        final s = e.toString();
        if (s == placeholder) {
          return defaultAvatarUrl;
        }
        return s;
      })
      .toList();

  return Chat(
    chatId: json['chatId'] as String,
    chatName: json['chatName'] as String,
    chatPicture: pics,                              // never null
    lastMessage: json['lastMessage'] as String,
    sentDate: DateTime.parse(json['sentDate'] as String),
    unreadCount: json['unreadCount'] as int,
    isRead: json['isRead'] as bool,
  );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'chatName': chatName,
      'chatPicture': chatPicture,
      'lastMessage': lastMessage,
      'sentDate': sentDate,
      'unreadCount': unreadCount,
      'isRead': isRead,
    };
  }
}

// Data model for a participant in a chat


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

//==============================Mock Data===========================//

List<Chat> mockChats = [
  Chat(
    chatId: "chat_001",
    chatName: "اخويا الجيار في اللة",
    chatPicture:
        ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQybOhACvhkP99hH4-8UVZyRs429BfgjPBiNA&s",],
    lastMessage: "انزل يا متدلع",
   sentDate: DateTime.now().subtract(Duration(hours: 1)),
    unreadCount: 2,
    isRead: true
  ),
  Chat(
    chatId: "chat_002",
    chatName: "عم احمد",
    chatPicture:
        ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFhJVW-WJ9ShTQP5iQtnp_jqxbI5VB_Fm3NHgirqN_GXZ2wNDwxgq_s0E6MmL5uwhUj0o&usqp=CAU",],
    lastMessage: "You: انت منين ؟",
    sentDate: DateTime.now().subtract(Duration(hours: 2)),
    unreadCount: 0,
    isRead: false,
  ),
  Chat(
    chatId: "chat_003",
    chatName: "ٍSakr ",
    chatPicture:
        ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFinmoBS3C0r1jV9YOTvO6HFLcrDYYffSN-i7LJs6fAsJ24SV3-lpLKvTpp1WnCJWbUP4&usqp=CAU",],
    lastMessage: "Sakr: Ana awel el dof3a",
    sentDate: DateTime.now().subtract(Duration(hours: 7)),
    unreadCount: 1,
    isRead: true,
  ),
  Chat(
    chatId: "chat_004",
    chatName: "Ahmed Hesham",
    chatPicture:
        ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsyI44s5kurKNs7i-ZSj0JlEGcBlCdAYGegg&s",],
    lastMessage: "Ahmed Hesham: اخلص يبني الديدلاين قرب",
    sentDate: DateTime.now().subtract(Duration(days: 1, hours: 4)),
    unreadCount: 3,
    isRead: false,
  ),
  Chat(
    chatId: "chat_005",
    chatName: "Margot Robbie",
    chatPicture:
        ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReFc97WTW0sr9jvt-3n9_01sJdimMpIL9lxpNJytt6kIeSbRHEjNxBQrZ8yHipEMdxyyw&usqp=CAU",],
    lastMessage: "Margot Robbie: Night darling ❤️❤️",
    sentDate: DateTime.now().subtract(Duration(days: 1, hours: 7)),
    unreadCount: 0,
    isRead: true,
  ),
  Chat(
    chatId: "chat_006",
    chatName: "رفاعي الدسوقي",
    chatPicture:
        ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMxvaC8-Kta2gPWHD-yo9rX9bg_uCWVIkQRw&s",],
    lastMessage:  "...عارف ياض يا دسوقي الفرق ما بين",
    sentDate: DateTime.now().subtract(Duration(days: 2, hours: 5)),
    unreadCount: 0,
    isRead: false,
  ),
  // Chat(
  //   chatId: "chat_007",
  //   chatName: "Georgina",
  //   chatPicture:
  //        ["https://v.wpimg.pl/NWJkMGEyYTYrCTt0agJsI2hRby4sW2J1P0l3ZWpAfW8yXn9_ah8nOy8ZKDcqVyklPxssMDVXPjtlCj0uag9_eC4CPjcpGDd4LwYvIiFWfWR5Wi4hJ0pjYXlaL2pxHC1jZwkvJSZUfWd6D3glIUkvZXMKbzo",],
  //   lastMessage: "Georgina: Are you free later ",
  //   sentDate: DateTime.now().subtract(Duration(days: 2, hours: 9)),
  //   unreadCount: 0,
  //   isRead: true,
  //  ),
  Chat(
    chatId: "chat_008",
    chatName: "Henry Scott",
    chatPicture: null,
    lastMessage:"Thanks for the update!",
    sentDate: DateTime.now().subtract(Duration(days: 3, hours: 4)),
    unreadCount: 0,
    isRead: false,
  ),
  Chat(
    chatId: "chat_009",
    chatName: "Isabella Green",
    chatPicture: null,
    lastMessage: "I’ll be there in 10 mins.",
    sentDate: DateTime.now().subtract(Duration(days: 3, hours: 6)),
    unreadCount: 2,
    isRead: true,
  ),
  Chat(
    chatId: "chat_010",
    chatName: "Jack Robinson",
    chatPicture: null,
    lastMessage: "Can you send me the document?",
    sentDate: DateTime.now().subtract(Duration(days: 4, hours: 2)),
    unreadCount: 1,
    isRead: false,
  ),
  Chat(
    chatId: "chat_011",
    chatName: "Karen Lopez",
    chatPicture: null,
    lastMessage:  "Sure! Sending it now.",
    sentDate: DateTime.now().subtract(Duration(days: 5, hours: 1)),
    unreadCount: 0,
    isRead: true,
  ),
  Chat(
    chatId: "chat_012",
    chatName: "Isabella Blue",
    chatPicture: null,
    lastMessage:"I’ll be there in 10 mins.",
    sentDate: DateTime.now().subtract(Duration(days: 6, hours: 4)),
    unreadCount: 2,
    isRead: true,
  ),
  Chat(
    chatId: "chat_010",
    chatName: "David White",
    chatPicture: null,
    lastMessage: "Can you send me the document?",
    sentDate: DateTime.now().subtract(Duration(days: 8, hours: 2)),
    unreadCount: 1,
    isRead: false,
  ),
  Chat(
    chatId: "chat_011",
    chatName: "Karen kiro",
    chatPicture: null,
    lastMessage:  "Sure! Sending it now.",
    sentDate: DateTime.now().subtract(Duration(days: 9, hours: 1)),
    unreadCount: 0,
    isRead: true,
  ),
];
    

//================================Back Up========================================//

// //===============================Last Message Model(DTO)=========================//

// import 'package:intl/intl.dart';

// class LastMessage {
//   final String? senderID;
//   final String? text;
//   final DateTime? timestamp;
//   String? time;
//   final String? messageType;

//   LastMessage({
//       required this.senderID,
//       required this.text,
//       required this.timestamp,
//       required this.messageType
//       }) {time = formatDynamicTime(timestamp!);}

//   factory LastMessage.fromJson(Map<String, dynamic> json) {
//     return LastMessage(
//       senderID: json['senderID'],
//       text: json['text'],
//       timestamp: DateTime.fromMillisecondsSinceEpoch(json['time']),
//       messageType: json['messageType'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'senderID': senderID,
//       'text': text,
//       'time': time,
//       'messageType': messageType,
//     };
//   }



// //==============================Chat Model(DTO)=================================//

// class Chat {
//   final String? id;
//   final String? userID;
//   final String? userName;
//   final String? userAvatar;
//   final bool? isOnline;
//   final String? lastSender;
//   //final List<String> participants;
//   final LastMessage? lastMessage;
//   final int? unreadCount;
//   final DateTime? lastUpdate;

//   Chat({
//     required this.id,
//     required this.userID,
//     required this.userName,
//     required this.userAvatar,
//     required this.isOnline,
//     required this.lastSender,
//     //required this.participants,
//     required this.lastMessage,
//     required this.unreadCount,
//     required this.lastUpdate,
//   });

//   factory Chat.fromJson(Map<String, dynamic> json) {
//     return Chat(
//         id: json['id'],
//         userID: json['userID'],
//         userName: json['userName'],
//         userAvatar: json['userAvatar'],
//         isOnline: json['isOnline'],
//         lastSender: json['lastSender'],
//         //participants:List<String>.from(json['participants']),
//         lastMessage: LastMessage.fromJson(json['lastMessage']),
//         unreadCount: json['unreadCount'],
//         lastUpdate: DateTime.fromMillisecondsSinceEpoch(json['lastUpdated']));
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userID': userID,
//       'userName': userName,
//       'userAvatar': userAvatar,
//       'isOnline': isOnline,
//       'lastSender': lastSender,
//       //'participants':participants,
//       'lastMessage': lastMessage!.toJson(),
//       'unreadCount': unreadCount,
//       'lastUpdate': lastUpdate,
//     };
//   }
// }



// List<Chat> mockChats = [
//   Chat(
//     id: "conv_001",
//     userID: "user2",
//     userName: "اخويا الجيار في اللة",
//     userAvatar:
//         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQybOhACvhkP99hH4-8UVZyRs429BfgjPBiNA&s",
//     lastMessage: LastMessage(
//       senderID: "user2",
//       text: "انزل يا متدلع",
//       timestamp: DateTime.now().subtract(Duration(minutes: 10)),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(minutes: 10)),
//     unreadCount: 2,
//     lastSender: "Alice Johnson",
//     isOnline: true,
//   ),
//   Chat(
//     id: "conv_002",
//     userID: "user3",
//     userName: "عم احمد",
//     userAvatar:
//         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFhJVW-WJ9ShTQP5iQtnp_jqxbI5VB_Fm3NHgirqN_GXZ2wNDwxgq_s0E6MmL5uwhUj0o&usqp=CAU",
//     lastMessage: LastMessage(
//       senderID: "user1",
//       text: "انت منين ؟",
//       timestamp: DateTime.now().subtract(Duration(hours: 1)),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(hours: 1)),
//     unreadCount: 0,
//     lastSender: "You",
//     isOnline: false,
//   ),
//   Chat(
//     id: "conv_003",
//     userID: "user4",
//     userName: "ٍSakr ",
//     userAvatar:
//         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFinmoBS3C0r1jV9YOTvO6HFLcrDYYffSN-i7LJs6fAsJ24SV3-lpLKvTpp1WnCJWbUP4&usqp=CAU",
//     lastMessage: LastMessage(
//       senderID: "user4",
//       text: "Ana awel el dof3a",
//       timestamp: DateTime.now().subtract(Duration(hours: 1)),
//       messageType: "file",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(hours: 1)),
//     unreadCount: 1,
//     lastSender: "Charlie Davis",
//     isOnline: true,
//   ),
//   Chat(
//     id: "conv_004",
//     userID: "user5",
//     userName: "Ahmed Hesham",
//     userAvatar:
//         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsyI44s5kurKNs7i-ZSj0JlEGcBlCdAYGegg&s",
//     lastMessage: LastMessage(
//       senderID: "user5",
//       text: "اخلص يبني الديدلاين قرب",
//       timestamp: DateTime.now().subtract(Duration(days: 0, hours: 3)),
//       messageType: "image",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(days: 0, hours: 3)),
//     unreadCount: 3,
//     lastSender: "Ahmed Hesham",
//     isOnline: false,
//   ),
//   Chat(
//     id: "conv_005",
//     userID: "user6",
//     userName: "Margot Robbie",
//     userAvatar:
//         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReFc97WTW0sr9jvt-3n9_01sJdimMpIL9lxpNJytt6kIeSbRHEjNxBQrZ8yHipEMdxyyw&usqp=CAU",
//     lastMessage: LastMessage(
//       senderID: "user6",
//       text: "Night darling ❤️❤️",
//       timestamp: DateTime.now().subtract(Duration(days: 0, hours: 4)),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(days: 0, hours: 4)),
//     unreadCount: 0,
//     lastSender: "Emma Wilson",
//     isOnline: true,
//   ),
//   Chat(
//     id: "conv_006",
//     userID: "user7",
//     userName: "رفاعي الدسوقي",
//     userAvatar:
//         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMxvaC8-Kta2gPWHD-yo9rX9bg_uCWVIkQRw&s",
//     lastMessage: LastMessage(
//       senderID: "user1",
//       text: "...عارف ياض يا دسوقي الفرق ما بين",
//       timestamp: DateTime.now().subtract(Duration(days: 0, hours: 6)),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(days: 0, hours: 6)),
//     unreadCount: 0,
//     lastSender: "You",
//     isOnline: false,
//   ),
//   // Chat(
//   //   id: "conv_007",
//   //   userID: "user8",
//   //   userName: "Georgina",
//   //   userAvatar:
//   //       "https://v.wpimg.pl/NWJkMGEyYTYrCTt0agJsI2hRby4sW2J1P0l3ZWpAfW8yXn9_ah8nOy8ZKDcqVyklPxssMDVXPjtlCj0uag9_eC4CPjcpGDd4LwYvIiFWfWR5Wi4hJ0pjYXlaL2pxHC1jZwkvJSZUfWd6D3glIUkvZXMKbzo",
//   //   lastMessage: LastMessage(
//   //     senderID: "user8",
//   //     text: "Are you free later ;)",
//   //     timestamp: DateTime.now().subtract(Duration(days: 0, hours: 8)),
//   //     messageType: "text",
//   //   ),
//   //   lastUpdate: DateTime.now().subtract(Duration(days: 0, hours: 8)),
//   //   unreadCount: 4,
//   //   lastSender: "Grace Martinez",
//   //   isOnline: true,
//   // ),
//   Chat(
//     id: "conv_008",
//     userID: "user9",
//     userName: "Henry Scott",
//     userAvatar: null,
//     lastMessage: LastMessage(
//       senderID: "user1",
//       text: "Thanks for the update!",
//       timestamp: DateTime.now().subtract(Duration(days: 2, hours: 1)),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(days: 2, hours: 1)),
//     unreadCount: 0,
//     lastSender: "You",
//     isOnline: false,
//   ),
//   Chat(
//     id: "conv_009",
//     userID: "user10",
//     userName: "Isabella Green",
//     userAvatar: null,
//     lastMessage: LastMessage(
//       senderID: "user10",
//       text: "I’ll be there in 10 mins.",
//       timestamp: DateTime.now().subtract(Duration(days: 3, hours: 4)),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(days: 3, hours: 4)),
//     unreadCount: 2,
//     lastSender: "Isabella Green",
//     isOnline: true,
//   ),
//   Chat(
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
//   ),
//   Chat(
//     id: "conv_011",
//     userID: "user12",
//     userName: "Karen Lopez",
//     userAvatar: null,
//     lastMessage: LastMessage(
//       senderID: "user12",
//       text: "Sure! Sending it now.",
//       timestamp: DateTime.now().subtract(Duration(days: 5, hours: 1)),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(days: 5, hours: 1)),
//     unreadCount: 0,
//     lastSender: "You",
//     isOnline: true,
//   ),
//   Chat(
//     id: "conv_012",
//     userID: "user13",
//     userName: "Isabella Blue",
//     userAvatar: null,
//     lastMessage: LastMessage(
//       senderID: "user13",
//       text: "I’ll be there in 10 mins.",
//       timestamp: DateTime.now().subtract(Duration(days: 6, hours: 4)),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(days: 6, hours: 4)),
//     unreadCount: 2,
//     lastSender: "Isabella Bliue",
//     isOnline: true,
//   ),
//   Chat(
//     id: "conv_010",
//     userID: "user14",
//     userName: "David White",
//     userAvatar: null,
//     lastMessage: LastMessage(
//       senderID: "user14",
//       text: "Can you send me the document?",
//       timestamp: DateTime.now().subtract(Duration(days: 8, hours: 2)),
//       messageType: "file",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(days: 8, hours: 2)),
//     unreadCount: 1,
//     lastSender: "David White",
//     isOnline: false,
//   ),
//   Chat(
//     id: "conv_011",
//     userID: "user15",
//     userName: "Karen kiro",
//     userAvatar: null,
//     lastMessage: LastMessage(
//       senderID: "user1",
//       text: "Sure! Sending it now.",
//       timestamp: DateTime.now().subtract(Duration(days: 9, hours: 1)),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now().subtract(Duration(days: 9, hours: 1)),
//     unreadCount: 0,
//     lastSender: "You",
//     isOnline: true,
//   ),
// ];
    