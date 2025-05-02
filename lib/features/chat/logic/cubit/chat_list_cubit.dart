import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepo chatRepo;
  List<Chat> _chats = [];
  ChatDetail? _chatDetail;
  Chat? _chat;
  final Set<String> selectedIds = {};

  ChatListCubit(this.chatRepo) : super(ChatListInitial());

  set chats(List<Chat> chats) {
    _chats = chats;
    emit(ChatListLoaded(chats: _chats));
  }

  Future<void> getAllChats() async {
    emit(ChatListLoading());
    selectedIds.clear();
    try {
      _chats = await chatRepo.getAllChats()!;
      if (_chats.isEmpty) {
        emit(ChatListEmpty());
      } else {
        emit(ChatListLoaded(chats: _chats));
      }
    } catch (e) {
      emit(ChatListErrorLoading(e.toString()));
    }
  }

  Future<void> reloadChats() async {
    try {
      _chats = await chatRepo.getAllChats()!;
      if (_chats.isEmpty) {
        emit(ChatListEmpty());
      } else {
        emit(ChatListLoaded(chats: _chats));
      }
    } catch (e) {
      emit(ChatListErrorLoading(e.toString()));
    }
  }

  Future<Chat> getChatById(String chatId) async {
    emit(ChatLoading());
    try {
      _chat = await chatRepo.getChatById(chatId)!;
      emit(ChatLoaded(chat: _chat!));
      return _chat!;
    } catch (e) {
      emit(ChatErrorLoading(e.toString()));
      return Future.error(e);
    }
  }

  Future<void> getChatDetails(String chatId) async {
    emit(ChatDetailLoading());
    try {
      _chatDetail = await chatRepo.getChatDetails(chatId);
      emit(ChatDetailLoaded(chatDetail: _chatDetail!));
    } catch (e) {
      emit(ChatDetailErrorLoading(e.toString()));
    }
  }

  void searchChats(String query) {
    if (query.isEmpty) {
      emit(ChatListLoaded(chats: _chats));
    } else {
      final searchedChat = _chats
          .where((chat) =>
              chat.chatName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (searchedChat.isNotEmpty) {
        emit(ChatListSearch(searchedChat));
      } else {
        emit(ChatListEmpty());
      }
    }
  }

  void addNewChat(Chat chat) {
    _chats.insert(0, chat);
    emit(ChatListNewChat(chat));
    emit(ChatListLoaded(chats: _chats));
  }

  void addNewMessage() {}

  void filteredChats(bool onlyUnread) {
    final filteredChats = onlyUnread
        ? _chats.where((chat) => (chat.unreadCount! > 0)||(chat.isRead == false)).toList()
        : _chats;
    emit(ChatListFilter(filteredChats));
  }

  void toggleSelection(String chatId) {
    if (selectedIds.contains(chatId)) {
      selectedIds.remove(chatId);
    } else {
      selectedIds.add(chatId);
    }

    if (selectedIds.isNotEmpty) {
      emit(ChatListSelected(
        chats: _chats,
        selectedIds: Set.from(selectedIds),
      ));
    } else {
      emit(ChatListLoaded(chats: _chats));
    }
  }

  /// Exit selection mode
  void clearSelection() {
    selectedIds.clear();
    emit(ChatListLoaded(chats: _chats));
  }

  /// Marks selected chats read/unread based on [markRead]
  Future<void> markReadOrUnreadSelected(bool markRead) async {
    for (var id in selectedIds) {
      print("cubit marking");
      await chatRepo.markReadOrUnread(id);
    }
    selectedIds.clear();
    //await getAllChats();
    _chats = await chatRepo.getAllChats()!;
    emit(ChatListLoaded(chats: _chats));
  }

  /// Deletes selected chats
  Future<void> deleteSelected() async {
    for (var id in selectedIds) {
      await chatRepo.deleteChat(id);
    }
    selectedIds.clear();
    await getAllChats();
  }

  /// Archives selected chats
  Future<void> archiveSelected() async {
    for (var id in selectedIds) {
      await chatRepo.archiveChat(id);
    }
    selectedIds.clear();
    await getAllChats();
  }

  void setTyping(String chatId, bool isTyping) {
    // Update the chat in the list with typing status
    final updatedChats = (_chats).map((chat) {
      if (chat.chatId == chatId) {
        chat.isTyping = isTyping;
      }
      return chat;
    }).toList();
    emit(ChatListLoaded(chats: updatedChats));
  }

  void updateChatCard(Map<String, dynamic> data) {
    // Update chat card info (last message, unread count, etc.)
    print(data);
    print(data['chatId']);
    print(data['lastMessage']);
    Chat newChat = Chat.fromJson(data);
    final chatId = newChat.chatId;
    final index = _chats.indexWhere((chat) => chat.chatId == chatId);
      if (index != -1) {
    _chats.removeAt(index);
  }
  _chats.insert(0, newChat);
  emit(ChatListLoaded(chats: List<Chat>.from(_chats)));
  }
}

//   Future<void> getAllChats() async {
//   emit(ChatListLoading());
//   try {
//     final chats = await chatRepo.getAllChats();
//     emit(ChatListLoaded(chats: chats));
//   } catch (e) {
//     emit(ChatListErrorLoading(e.toString()));
//   }
// }
  // final updatedChats = _chats.map((chat) {
    //   if (chat.chatId == chatId) {
    //     chat = newChat;
    //   }
    //   return chat;
    // }).toList();
    //emit(ChatListLoaded(chats: updatedChats));