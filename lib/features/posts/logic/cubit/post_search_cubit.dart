import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/logic/cubit/post_search_state.dart';

class PostSearchCubit extends Cubit<PostSearchState> {
  final PostRepo _postRepo;

  PostSearchCubit(this._postRepo) : super(PostSearchInitial());

  Future<void> searchPosts(String searchText, {int? start, int? end}) async {
    emit(PostSearchLoading());

    try {
      if (searchText.isEmpty) {
        emit(PostSearchInitial());
        return;
      }

      final posts =
          await _postRepo.searchPosts(searchText, start: start, end: end);
      emit(PostSearchLoaded(posts: posts, searchTerm: searchText));
    } catch (e) {
      emit(PostSearchError(e.toString()));
    }
  }

  void resetSearch() {
    emit(PostSearchInitial());
  }
}
