part of 'chat_list_cubit.dart';

//@immutable
abstract class ChatListState {}

final class ChatListInitial extends ChatListState {}

final class ChatListLoading extends ChatListState {}
final class ChatListLoaded extends ChatListState{
  final List<Chat> chats;
  ChatListLoaded({required this.chats});
}

final class ChatListEmpty extends ChatListState{}
final class ChatListErrorLoading extends ChatListState{
  final String errorMessage;
  ChatListErrorLoading(this.errorMessage);
}


final class ChatListNewChat extends ChatListState {
  final Chat newChat;
  ChatListNewChat(this.newChat);
}
final class ChatListNewMessage extends ChatListState {
  final String newMessage;
  ChatListNewMessage(this.newMessage);
}
final class ChatListSearch extends ChatListState {
  final List<Chat> searchChats;
  ChatListSearch(this.searchChats);
}
final class ChatListFilter extends ChatListState {
  final List<Chat> filteredChats;
  ChatListFilter(this.filteredChats);
}
class ChatListSelected extends ChatListState {
  final List<Chat> chats;
  final Set<String> selectedIds;
  ChatListSelected({
    required this.chats,
    required this.selectedIds,
  });}

final class ChatDetailLoading extends ChatListState {}
final class ChatDetailLoaded extends ChatListState {
  final ChatDetail chatDetail;
  ChatDetailLoaded({required this.chatDetail});
}
final class ChatDetailEmpty extends ChatListState {}
final class ChatDetailErrorLoading extends ChatListState {
  final String errorMessage;
  ChatDetailErrorLoading(this.errorMessage);}

