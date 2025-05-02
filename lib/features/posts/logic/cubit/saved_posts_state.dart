import 'package:joblinc/features/posts/data/models/post_model.dart';

abstract class SavedPostsState {}

class SavedPostsInitial extends SavedPostsState {}

class SavedPostsLoading extends SavedPostsState {}

class SavedPostsLoaded extends SavedPostsState {
  List<PostModel> posts;
  SavedPostsLoaded(this.posts);
}

class SavedPostsFailure extends SavedPostsState {
  String e;
  SavedPostsFailure(this.e);
}
