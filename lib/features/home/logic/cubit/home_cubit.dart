import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

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
      final response = await _postRepo.getFeed();
      final user = await _postRepo.getUserInfo();
      emit(HomeLoaded(posts: response, user: user));
    } catch (e) {
      emit(HomePostsFailure(e.toString()));
    }
  }

  Future<void> getUserInfo() async {
    emit(HomePostsLoading());
    try {
      final response = await _postRepo.getUserInfo();
      emit(HomeLoaded(posts: [], user: response));
    } catch (e) {
      emit(HomePostsFailure(e.toString()));
    }
  }
}
