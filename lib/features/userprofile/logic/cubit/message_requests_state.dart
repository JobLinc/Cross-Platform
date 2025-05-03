part of 'message_requests_cubit.dart';

abstract class MessageRequestsState {}

class MessageRequestsInitial extends MessageRequestsState {}

class MessageRequestsLoading extends MessageRequestsState {}

class MessageRequestsLoaded extends MessageRequestsState {
  final List<Chat> chats;

  MessageRequestsLoaded({required this.chats});
}

class MessageRequestsError extends MessageRequestsState {
  final String message;

  MessageRequestsError({required this.message});
}

class MessageRequestAccepted extends MessageRequestsState 
{
  final String message;

  MessageRequestAccepted({required this.message});
}
class MessageRequestRejected extends MessageRequestsState 
{
  final String message;

  MessageRequestRejected({required this.message});
}
