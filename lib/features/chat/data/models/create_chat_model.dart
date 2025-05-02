import 'package:joblinc/features/chat/data/models/message_model.dart';

class CreateChatModel {
  final String chatId;
  final String chatName;
  final List<String> chatPicture;
  final String type;
  final List<Participant> participants;
  final List<dynamic> messages;

  CreateChatModel({
    required this.chatId,
    required this.chatName,
    required this.chatPicture,
    required this.type,
    required this.participants,
    required this.messages,
  });

  factory CreateChatModel.fromJson(Map<String, dynamic> json) {
    return CreateChatModel(
      chatId: json['chatId'] as String,
      chatName: json['chatName'] as String,
      chatPicture: List<String>.from(json['chatPicture'] ?? []),
      type: json['type'] as String,
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => Participant.fromJson(e))
              .toList() ??
          [],
      messages: json['messages'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'chatName': chatName,
      'chatPicture': chatPicture,
      'type': type,
      'participants': participants.map((e) => e.toJson()).toList(),
      'messages': messages,
    };
  }
}

class CreateChatParticipant {
  final String userId;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final bool isRemoved;

  CreateChatParticipant({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.isRemoved,
  });

  factory CreateChatParticipant.fromJson(Map<String, dynamic> json) {
    return CreateChatParticipant(
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profilePicture: json['profilePicture'] as String,
      isRemoved: json['isRemoved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
      'isRemoved': isRemoved,
    };
  }
}
