import 'package:bloc/bloc.dart';
//import 'package:get_it/get_it.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/ui/screens/chat_list_screen.dart';
//import 'package:joblinc/features/chat/logic/cubit/chat_cubit.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {


  final ChatRepo chatRepo;
  late List<Chat> _chats =[];

  ChatListCubit(this.chatRepo) : super(ChatListInitial());

  Future<void> getAllChats() async{
    
    emit(ChatListLoading());

    try {
      _chats=await chatRepo.getAllChats();
      if (_chats.isEmpty){
        emit(ChatListEmpty());
      } else{
        emit(ChatListLoaded(chats: _chats ));
      }
    } catch (e) {
      print("Error loading chats: $e");
      //print("StackTrace: $stackTrace");
      emit(ChatListErrorLoading(e.toString()));
    } 
  }



  void searchChats(String query){
    if (query.isEmpty){
      emit(ChatListLoaded(chats: _chats));
    } else {
      final searchedChat = _chats.where((chat) =>chat.userName!.toLowerCase().contains(query.toLowerCase())).toList();
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
    final filteredChats= onlyUnread ? _chats.where((chat)=>chat.unreadCount! > 0).toList():_chats;
    emit(ChatListFilter(filteredChats));
  }
}