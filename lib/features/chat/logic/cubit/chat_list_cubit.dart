import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {


  final ChatRepo chatRepo;
  List<Chat> _chats =[];
  ChatDetail? _chatDetail;
  final Set<String> _selectedIds = {};

  ChatListCubit(this.chatRepo) : super(ChatListInitial());

  Future<void> getAllChats() async{
    emit(ChatListLoading());
    _selectedIds.clear();
    try {
      _chats=await chatRepo.getAllChats();
      if (_chats.isEmpty){
        emit(ChatListEmpty());
      } else{
        emit(ChatListLoaded(chats: _chats ));
      }
    } catch (e) {
      emit(ChatListErrorLoading(e.toString()));
    } 
  }

    Future<void> getChatDetails(String chatId) async{
    emit(ChatDetailLoading());
    try {
      _chatDetail=await chatRepo.getChatDetails(chatId);
        emit(ChatDetailLoaded(chatDetail: _chatDetail! ));
    } catch (e) {
      emit(ChatDetailErrorLoading(e.toString()));
    } 
  }






  void searchChats(String query){
    if (query.isEmpty){
      emit(ChatListLoaded(chats: _chats));
    } else {
      final searchedChat = _chats.where((chat) =>chat.chatName.toLowerCase().contains(query.toLowerCase())).toList();
      if(searchedChat.isNotEmpty){
        emit(ChatListSearch(searchedChat));
      }
      else{
        emit(ChatListEmpty());
      }
    }
  }

  void addNewChat(Chat chat){
    _chats.insert(0,chat);
    emit(ChatListNewChat(chat));
    emit(ChatListLoaded(chats: _chats));
  }

  void addNewMessage(){}

  void filteredChats(bool onlyUnread){
    final filteredChats= onlyUnread ? _chats.where((chat)=>chat.unreadCount > 0).toList():_chats;
    emit(ChatListFilter(filteredChats));
  }




  void toggleSelection(String chatId) {
    if (_selectedIds.contains(chatId)) {
      _selectedIds.remove(chatId);
    } else {
      _selectedIds.add(chatId);
    }

    if (_selectedIds.isNotEmpty) {
      emit(ChatListSelected(
        chats: _chats,
        selectedIds: Set.from(_selectedIds),
      ));
    } else {
      emit(ChatListLoaded(chats: _chats));
    }
  }

  /// Exit selection mode
  void clearSelection() {
    _selectedIds.clear();
    emit(ChatListLoaded(chats: _chats));
  }


  /// Marks selected chats read/unread based on [markRead]
  Future<void> markReadOrUnreadSelected(bool markRead) async {
    for (var id in _selectedIds) {
      await chatRepo.markReadOrUnread(id);
    }
    _selectedIds.clear();
    await getAllChats();
  }

  /// Deletes selected chats
  Future<void> deleteSelected() async {
    for (var id in _selectedIds) {
      await chatRepo.deleteChat(id);
    }
    _selectedIds.clear();
    await getAllChats();
  }

  /// Archives selected chats
  Future<void> archiveSelected() async {
    for (var id in _selectedIds) {
      await chatRepo.archiveChat(id);
    }
    _selectedIds.clear();
    await getAllChats();
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