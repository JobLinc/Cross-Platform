import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/logic/cubit/saved_posts_state.dart';

class SavedPostsCubit extends Cubit<SavedPostsState> {
  SavedPostsCubit(this._postRepo) : super(SavedPostsInitial());
  final PostRepo _postRepo;

  Future<void> getSavedPosts() async {
    emit(SavedPostsLoading());
    try {
      final posts = await _postRepo.getSavedPosts();
      emit(SavedPostsLoaded(posts));
    } catch (e) {
      emit(SavedPostsFailure(e.toString()));
    }
  }
}
