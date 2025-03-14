import 'package:bloc/bloc.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
//import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {

  final ChatRepo _chatRepo;
  late List<Chat> chats;
  ChatCubit(this._chatRepo) : super(ChatInitial());

  List<Chat> getAllChats(){
    _chatRepo.getAllChats().then((responseChats){
      emit(ChatLoaded(chats: responseChats as List<Chat>));
      this.chats=responseChats as List<Chat>;
    });
    return chats;
  }
}
