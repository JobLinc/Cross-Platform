import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/services/chat_api_service.dart';
//import 'package:flutter/material.dart';

class ChatRepo {
  final ChatApiService _chatApiService;

  ChatRepo(this._chatApiService);

  Future<List<Chat>> getAllChats() async {
    final List<dynamic> chats = (await _chatApiService.getAllChats()) ;
    
    if (chats is List<Chat>){
      return chats;
    }
    else{
    return chats.map((chat) =>Chat.fromJson(chat)).toList();
    }
  } 
}