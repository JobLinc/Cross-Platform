import 'package:bloc/bloc.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final PostRepo _postRepo;

  HomeCubit(this._postRepo) : super(HomeInitial());

  // Future<void> getPost(String postID) async {
  //   emit(HomePostsLoading());
  //   final response = await _postRepo.getPost(postID);
  // }

  Future<void> getFeed(int amount) async {
    emit(HomePostsLoading());

    try {
      final response = await _postRepo.getFeed(amount);
      emit(HomePostsFetched(response));
    } catch (e) {
      emit(HomePostsFailure(e.toString()));
    }
  }
}
