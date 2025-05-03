import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_posts_state.dart';

class ProfilePostsCubit extends Cubit<ProfilePostsState> {
  final PostRepo _postRepo;

  ProfilePostsCubit(this._postRepo) : super(ProfilePostsInitial());

  Future<void> loadProfilePosts() async {
    emit(ProfilePostsLoading());

    try {
      final posts = await _postRepo.getMyPosts();
      emit(ProfilePostsLoaded(posts));
    } catch (e) {
      if (!isClosed) {
        emit(ProfilePostsError(e.toString()));
      }
    }
  }

  Future<void> loadOthersProfilePosts(String userId) async {
    emit(ProfilePostsLoading());

    try {
      final posts = await _postRepo.getUserPosts(userId);
      emit(ProfilePostsLoaded(posts));
    } catch (e) {
      emit(ProfilePostsError(e.toString()));
    }
  }
}
