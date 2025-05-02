import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/userprofile/data/repo/user_profile_repository.dart';

part 'message_requests_state.dart';

class MessageRequestsCubit extends Cubit<MessageRequestsState> {
  final UserProfileRepository chatRepository;

  MessageRequestsCubit(this.chatRepository) : super(MessageRequestsInitial());

  Future<void> fetchMessageRequests() async {
    emit(MessageRequestsLoading());
    try {
      final allChats = await chatRepository.fetchChatRequests();

      emit(MessageRequestsLoaded(chats: allChats));
    } catch (e) {
      emit(MessageRequestsError(message: e.toString()));
    }
  }
  Future<void> changeRequestStatus(String chatId, String status) async {
    try {
      // Emit loading state (optional, you can add loading state if needed)
      emit(MessageRequestsLoading());

      // Call the repository function to change the status
      Response response = await chatRepository.changeRequestStatus(
        chatId: chatId,
        status: status,
      );

      // Check if the response status code is successful
      if (response.statusCode == 200) {
          emit(MessageRequestAccepted(message: 'Message Request $status succefully'));
      } else {
        emit(MessageRequestsError(message: 'Failed to update request status.'));
      }
    } catch (e) {
      // If a DioException or any error occurs
      
        emit(MessageRequestsError(message: 'Error: ${e.toString()}'));
    
    }
  }
}
