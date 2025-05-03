import 'package:joblinc/features/posts/data/models/post_model.dart';

abstract class PostSearchState {}

class PostSearchInitial extends PostSearchState {}

class PostSearchLoading extends PostSearchState {}

class PostSearchLoaded extends PostSearchState {
  final List<PostModel> posts;
  final String searchTerm;

  PostSearchLoaded({required this.posts, required this.searchTerm});
}

class PostSearchError extends PostSearchState {
  final String message;

  PostSearchError(this.message);
}
