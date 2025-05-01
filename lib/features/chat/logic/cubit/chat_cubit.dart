
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {

    final ChatRepo chatRepo;
  ChatCubit(this.chatRepo) : super(ChatInitial());

  Future<void> uploadMedia(File file) async {
    emit(MediaUploading());
    try {
      final url = await chatRepo.uploadMedia(file);
      emit(MediaUploaded(url));
    } catch (e) {
      emit(MediaUploadingError(e.toString()));
    }
  }
}
