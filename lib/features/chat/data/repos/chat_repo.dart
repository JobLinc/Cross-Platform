import 'dart:io';

import 'package:dio/dio.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/services/chat_api_service.dart';
//import 'package:flutter/material.dart';

class ChatRepo {
  final ChatApiService _chatApiService;

  ChatRepo(this._chatApiService);

  Future<Chat>? getChatById(String chatId) async {
    final response = await _chatApiService.getAllChats();
        final List<Chat> chats = (response.data["chats"] as List)
      .map((chatJson) => Chat.fromJson(chatJson as Map<String, dynamic>))
      .toList();
    final chat = chats.firstWhere((chat) => chat.chatId == chatId);
      return chat;

  }

  Future<List<Chat>>? getAllChats() async {
    final response = await _chatApiService.getAllChats() ; 
    final List<Chat> chats = (response.data["chats"] as List)
      .map((chatJson) => Chat.fromJson(chatJson as Map<String, dynamic>))
      .toList();
    print(chats);
    return chats;
  }

    // Fetches details for a single chat by its ID and returns a ChatDetail object.
  Future<ChatDetail>? getChatDetails(String chatId) async {
    final response = await _chatApiService.getChatDetails(chatId);
    //print(ChatDetail.fromJson(response.data as Map<String, dynamic>));
    return ChatDetail.fromJson(response.data as Map<String, dynamic>);
  }

  /// Opens a chat by providing a list of receiver IDs and the sender ID.
  /// Returns the ChatDetail model.
  Future<void>? openChat(List<String> receiverIDs, String senderID) async {
    //Response response =
     await _chatApiService.openChat(receiverIDs:receiverIDs, senderID:senderID);
    //return ChatDetail.fromJson(response.data as Map<String, dynamic>);
  }

  // Deletes a chat specified by chatId.
  Future<void>? deleteChat(String chatId) async {
    await _chatApiService.deleteChat(chatId);
  }

  Future<void>? archiveChat (String chatId) async {
    await _chatApiService.archiveChat(chatId);
  }


  /// Changes the title of a chat and returns the updated Chat model.
  Future<void>? changeTitle(String chatId, String chatTitle) async {
    await _chatApiService.changeTitle(chatId: chatId, chatTitle: chatTitle);
  }

  /// Marks a chat as read (or similar) for a given user.
  Future<void>? markReadOrUnread(String chatId,) async {
    await _chatApiService.markReadOrUnread(chatId: chatId);
    // Optionally, process response if needed
  }

    Future<String> uploadMedia(File file) async {
    return await _chatApiService.uploadMedia(file);
  }

}

