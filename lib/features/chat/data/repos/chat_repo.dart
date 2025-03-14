import 'package:joblinc/features/Chat/data/models/chat_model.dart';
import 'package:joblinc/features/Chat/data/services/Chat_api_service.dart';
//import 'package:flutter/material.dart';

class ChatRepo {
  final ChatApiService _chatApiService;

  ChatRepo(this._chatApiService);

  Future<List<Chat>> getAllChats() async {
    final List<dynamic> chats = (await _chatApiService.getAllChats()) as List;
    return chats.map((chat) =>Chat.fromJson(chat)).toList();
  } 
}