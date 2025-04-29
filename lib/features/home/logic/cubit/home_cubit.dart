import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final PostRepo _postRepo;

  HomeCubit(this._postRepo) : super(HomeInitial());

  Future<void> getFeed({int? start, int? end}) async {
    emit(HomePostsLoading());

    try {
      final posts = await _postRepo.getFeed(start: start, end: end);
      final user = await _postRepo.getUserInfo();
      emit(HomeLoaded(posts: posts, user: user));
    } catch (e, stackTrace) {
      emit(HomePostsFailure(e.toString()));
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
