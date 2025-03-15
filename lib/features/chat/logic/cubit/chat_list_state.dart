part of 'chat_list_cubit.dart';

//@immutable
sealed class ChatListState {
  List<Object?> get props => [];
}

final class ChatListInitial extends ChatListState {}

final class ChatListLoading extends ChatListState {}

final class ChatListLoaded extends ChatListState{
  final List<Chat> chats;
  ChatListLoaded({required this.chats});
  @override
  List<Object?>get props =>[chats];
}


final class ChatListEmpty extends ChatListState{}


final class ChatListErrorLoading extends ChatListState{
  final String errorMessage;
  ChatListErrorLoading(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}


final class ChatListNewChat extends ChatListState {
  final Chat newChat;
  ChatListNewChat(this.newChat);
  @override
  List<Object?> get props => [newChat];
}


final class ChatListNewMessage extends ChatListState {
  final String newMessage;
  ChatListNewMessage(this.newMessage);
  @override
  List<Object?> get props => [newMessage];
}


final class ChatListSearch extends ChatListState {
  final List<Chat> searchChats;
  ChatListSearch(this.searchChats);
  @override
  List<Object?> get props => [searchChats]; 
}


final class ChatListFilter extends ChatListState {
  final List<Chat> filteredChats;
  ChatListFilter(this.filteredChats);
  @override
  List<Object?> get props => [filteredChats];
}