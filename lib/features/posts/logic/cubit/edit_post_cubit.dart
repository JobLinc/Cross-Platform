import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/logic/cubit/edit_post_state.dart';

class EditPostCubit extends Cubit<EditPostState> {
  final PostRepo _postRepo;

  EditPostCubit(this._postRepo) : super(EditPostInitial());

  Future<void> editPost(
      String postId, String text, List<PostmediaModel> mediaItems,
      {List<TaggedEntity> taggedUsers = const [],
      List<TaggedEntity> taggedCompanies = const []}) async {
    emit(EditPostLoading());

    try {
      await _postRepo.editPost(
        postId,
        text,
        mediaItems,
        taggedUsers: taggedUsers,
        taggedCompanies: taggedCompanies,
      );
      emit(EditPostSuccess());
    } catch (e) {
      emit(EditPostFailure(e.toString()));
    }
  }
}
