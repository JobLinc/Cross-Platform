part of 'chat_cubit.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}
class ChatLoading extends ChatState{}
class ChatLoaded extends ChatState{
  final List<Chat> chats;

  ChatLoaded({required this.chats});
}
class ChatErrorLoading extends ChatState{}
