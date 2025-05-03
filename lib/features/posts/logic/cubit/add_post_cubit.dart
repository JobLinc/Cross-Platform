import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_state.dart';

class AddPostCubit extends Cubit<AddPostState> {
  final PostRepo _postRepo;

  AddPostCubit(this._postRepo) : super(AddPostStateInitial());

  Future<void> addPost(
      String text, List<PostmediaModel> media, String? repostId, bool isPublic) async {
    emit(AddPostStateLoading());

    try {
      await _postRepo.addPost(text, media, repostId, isPublic);
      emit(AddPostStateSuccess());
    } catch (e) {
      emit(AddPostStateFailure(e.toString()));
    }
  }
}
