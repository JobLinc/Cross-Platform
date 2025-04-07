// Data model for the content of a message
import 'package:joblinc/features/chat/data/models/chat_model.dart';

class MessageContent {
  final String text;
  final String image;
  final String video;
  final String audio;
  final String document;

  MessageContent({
    required this.text,
    required this.image,
    required this.video,
    required this.audio,
    required this.document,
  });

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    return MessageContent(
      text: json['text'],
      image: json['image'],
      video: json['video'],
      audio: json['audio'],
      document: json['document'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'image': image,
      'video': video,
      'audio': audio,
      'document': document,
    };
  }
}

// Data model for a message in a chat
class Message {
  final String messageId;
  final MessageContent content;
  final int sentDate; // Unix timestamp in seconds
  final String senderId;
  final String status; // e.g., "delivered", "read", etc.

  Message({
    required this.messageId,
    required this.content,
    required this.sentDate,
    required this.senderId,
    required this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'],
      content: MessageContent.fromJson(json['content']),
      sentDate: json['sentDate'],
      senderId: json['senderId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'content': content.toJson(),
      'sentDate': sentDate,
      'senderId': senderId,
      'status': status,
    };
  }
}

// Data model for detailed chat info (GET /chat/c/{chatId} and POST /chat/openChat)
class ChatDetail {
  final String chatId;
  final String chatName;
  final String chatPicture; // Single picture URL in detail view
  final List<Participant> participants;
  final List<Message> messages;

  ChatDetail({
    required this.chatId,
    required this.chatName,
    required this.chatPicture,
    required this.participants,
    required this.messages,
  });

  factory ChatDetail.fromJson(Map<String, dynamic> json) {
    return ChatDetail(
      chatId: json['chatId'],
      chatName: json['chatName'],
      chatPicture: json['chatPicture'],
      participants: (json['participants'] as List)
          .map((e) => Participant.fromJson(e))
          .toList(),
      messages: (json['messages'] as List)
          .map((e) => Message.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'chatName': chatName,
      'chatPicture': chatPicture,
      'participants': participants.map((e) => e.toJson()).toList(),
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
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
