part of 'chat_cubit.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}
class ChatLoading extends ChatState{}




class MediaUploading extends ChatState {}
class MediaUploaded extends ChatState {
  final String url;
  MediaUploaded(this.url);
}
class MediaUploadingError extends ChatState {
  final String error;
  MediaUploadingError(this.error);
}

