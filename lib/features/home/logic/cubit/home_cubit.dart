import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/home/logic/cubit/home_state.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';


class HomeCubit extends Cubit<HomeState> {
  final PostRepo _postRepo;

  HomeCubit(this._postRepo) : super(HomeInitial());

  Future<void> getFeed({int? start, int? end}) async {
    emit(HomePostsLoading());

    List<PostModel>? posts;
    UserProfile? user;

    try {
      // Try to fetch posts
      try {
        posts = await _postRepo.getFeed(start: start, end: end);
      } catch (e) {
        print('Error fetching posts: $e');
        // Continue execution to try fetching user info
      }

      // Try to fetch user info
      try {
        user = await _postRepo.getUserInfo();
      } catch (e) {
        print('Error fetching user info: $e');
        // Continue execution
      }

      // If we have both posts and user, emit loaded state
      if (posts != null && user != null) {
        emit(HomeLoaded(posts: posts, user: user));
      } else {
        // Otherwise emit failure state with partial data
        String errorMessage = '';
        if (posts == null) errorMessage += 'Failed to load posts. ';
        if (user == null) errorMessage += 'Failed to load user profile. ';
        emit(HomePostsFailure(errorMessage, posts: posts, user: user));
      }
    } catch (e, stackTrace) {
      emit(HomePostsFailure(e.toString(), posts: posts, user: user));
      print(stackTrace);
    }
  }

  Future<void> getUserInfo() async {
    emit(HomePostsLoading());
    try {
      final response = await _postRepo.getUserInfo();
      emit(HomeLoaded(posts: [], user: response));
    } catch (e, stackTrace) {
      emit(HomePostsFailure(e.toString()));
      print(stackTrace);
    }
  }
}


