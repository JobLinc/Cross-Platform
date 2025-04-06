import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';

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
