// class Participant {
//   final String userId;
//   final String firstName;
//   final String lastName;
//   final String profilePicture;

//   Participant({
//     required this.userId,
//     required this.firstName,
//     required this.lastName,
//     required this.profilePicture,
//   });

//   factory Participant.fromJson(Map<String, dynamic> json) {
//     return Participant(
//       userId: json['userId'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       profilePicture: json['profilePicture'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'firstName': firstName,
//       'lastName': lastName,
//       'profilePicture': profilePicture,
//     };
//   }
// }

// class MessageContent {
//   final String text;
//   final String image;
//   final String video;
//   final String audio;
//   final String document;

//   MessageContent({
//     this.text="",
//     this.image="",
//     this.video="",
//     this.audio="",
//     this.document="",
//   });

//   factory MessageContent.fromJson(Map<String, dynamic> json) {
//     return MessageContent(
//       text: json['text'],
//       image: json['image'],
//       video: json['video'],
//       audio: json['audio'],
//       document: json['document'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'text': text,
//       'image': image,
//       'video': video,
//       'audio': audio,
//       'document': document,
//     };
//   }
// }

// // Data model for a message in a chat
// class Message {
//   final String messageId;
//   final MessageContent content;
//   final DateTime sentDate; 
//   final String senderId;
//   final String status; // e.g., "delivered", "read", etc.

//   Message({
//     required this.messageId,
//     required this.content,
//     required this.sentDate,
//     required this.senderId,
//     required this.status,
//   });

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       messageId: json['messageId'],
//       content: MessageContent.fromJson(json['content']),
//       sentDate: json['sentDate'],
//       senderId: json['senderId'],
//       status: json['status'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'messageId': messageId,
//       'content': content.toJson(),
//       'sentDate': sentDate,
//       'senderId': senderId,
//       'status': status,
//     };
//   }
// }

// // Data model for detailed chat info (GET /chat/c/{chatId} and POST /chat/openChat)
// class ChatDetail {
//   final String chatId;
//   final String chatName;
//   final List<String> chatPicture; // Single picture URL in detail view
//   final List<Participant> participants;
//   final List<Message> messages;

//   ChatDetail({
//     required this.chatId,
//     required this.chatName,
//     required this.chatPicture,
//     required this.participants,
//     required this.messages,
//   });

//   // factory ChatDetail.fromJson(Map<String, dynamic> json) {
//   //   return ChatDetail(
//   //     chatId: json['chatId'],
//   //     chatName: json['chatName'],
//   //     chatPicture: List<String>.from(json['chatPicture']),
//   //     participants: (json['participants'] as List)
//   //         .map((e) => Participant.fromJson(e))
//   //         .toList(),
//   //     messages: (json['messages'] as List)
//   //         .map((e) => Message.fromJson(e))
//   //         .toList(),
//   //   );
//   // }

//   factory ChatDetail.fromJson(Map<String, dynamic> json) {
//     // If the API sometimes omits chatPicture, fallback to participants' pics:
//     final picsRaw = json['chatPicture'] as List<dynamic>?;
//     final pics = picsRaw != null
//         ? picsRaw.map((e) => e.toString()).toList()
//         : (json['participants'] as List<dynamic>)
//             .map((p) => (p['profilePicture'] as String))
//             .toList();

//     return ChatDetail(
//       chatId:   json['chatId']   as String,   // make sure these exist
//       chatName: json['chatName'] as String,
//       chatPicture: pics,
//       participants: (json['participants'] as List)
//           .map((e) => Participant.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       messages: (json['messages'] as List)
//           .map((e) => Message.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }


//   Map<String, dynamic> toJson() {
//     return {
//       'chatId': chatId,
//       'chatName': chatName,
//       'chatPicture': chatPicture,
//       'participants': participants.map((e) => e.toJson()).toList(),
//       'messages': messages.map((e) => e.toJson()).toList(),
//     };
//   }
// }


class Participant {
  final String userId;
  final String firstName;
  final String lastName;
  final String profilePicture;

  Participant({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profilePicture: json['profilePicture'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'profilePicture': profilePicture,
      };
}

class MessageContent {
  final String text;
  final String image;
  final String video;
  final String audio;
  final String document;

  MessageContent({
    this.text = "",
    this.image = "",
    this.video = "",
    this.audio = "",
    this.document = "",
  });

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    return MessageContent(
      text: json['text'] as String? ?? "",
      image: json['image'] as String? ?? "",
      video: json['video'] as String? ?? "",
      audio: json['audio'] as String? ?? "",
      document: json['document'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'image': image,
        'video': video,
        'audio': audio,
        'document': document,
      };
}

class Message {
  String? messageId;
  String? type;
  List<String>? seenBy;
  final MessageContent content;
  final DateTime sentDate;
  final String senderId;

  Message({
    this.messageId,
    required this.type,
    this.seenBy,
    required this.content,
    required this.sentDate,
    required this.senderId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // parse the ISO string into a DateTime
    final sent = DateTime.parse(json['sentDate'] as String);

    // seenBy may be missing or null
    final rawSeen = json['seenBy'] as List<dynamic>?;
    final seenList = rawSeen?.map((e) => e as String).toList() ?? [];

    return Message(
      messageId: json['messageId'] as String,
      type: json['type'] as String? ?? 'text',
      seenBy: seenList,
      content:
          MessageContent.fromJson(json['content'] as Map<String, dynamic>),
      sentDate: sent,
      senderId: json['senderId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'type': type,
        'seenBy': seenBy,
        'content': content.toJson(),
        'sentDate': sentDate.toIso8601String(),
        'senderId': senderId,
      };
}

class ChatDetail {
  final String chatType;
  final List<Participant> participants;
  final List<Message> messages;

  ChatDetail({
    required this.chatType,
    required this.participants,
    required this.messages,
  });

  factory ChatDetail.fromJson(Map<String, dynamic> json) {
    return ChatDetail(
      chatType: json['chatType'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((p) => Participant.fromJson(p as Map<String, dynamic>))
          .toList(),
      messages: (json['messages'] as List<dynamic>)
          .map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'chatType': chatType,
        'participants': participants.map((p) => p.toJson()).toList(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };
}



Map<String, dynamic> mockChatDetail = {
  "chatId": "chat1",
  "chatName": "Family Group",
  "chatPicture": "https://www.example.com/pic1.jpg",
  "participants": [
    {
      "userId": "user1",
      "firstname": "John",
      "lastname": "Doe",
      "profilePicture": "https://www.example.com/profile1.jpg"
    },
    {
      "userId": "user2",
      "firstname": "Jane",
      "lastname": "Doe",
      "profilePicture": "https://www.example.com/profile2.jpg"
    }
  ],
  "messages": [
    {
      "messageId": "msg1",
      "content": {
        "text": "Hello, family!",
        "image": "",
        "video": "",
        "audio": "",
        "document": ""
      },
      "sentDate": 1672502400,
      "senderId": "user1",
      "status": "delivered"
    },
    {
      "messageId": "msg2",
      "content": {
        "text": "Hi John!",
        "image": "",
        "video": "",
        "audio": "",
        "document": ""
      },
      "sentDate": 1672506000,
      "senderId": "user2",
      "status": "read"
    }
  ]
};


Map<String, dynamic> mockOpenChatResponse = {
  "chatId": "chat3",
  "chatName": "New Group Chat",
  "chatPicture": [
    "https://www.example.com/pic5.jpg",
    "https://www.example.com/pic6.jpg"
  ],
  "participants": [
    {
      "userId": "user1",
      "firstname": "John",
      "lastname": "Doe",
      "profilePicture": "https://www.example.com/profile1.jpg"
    },
    {
      "userId": "user3",
      "firstname": "Alice",
      "lastname": "Smith",
      "profilePicture": "https://www.example.com/profile3.jpg"
    }
  ],
  "messages": [] // For a new chat, messages list is empty.
};

Map<String, dynamic> mockDeleteChatResponse = {
  "message": "Chat deleted successfully."
};

Map<String, dynamic> mockChangeTitleResponse = {
  "message": "Chat title changed successfully."
};

Map<String, dynamic> mockMarkChatResponse = {
  "message": "Chat marked successfully."
};
