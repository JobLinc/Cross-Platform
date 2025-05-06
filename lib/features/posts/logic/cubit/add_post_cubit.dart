import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/data/services/tag_suggestion_service.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_state.dart';

class AddPostCubit extends Cubit<AddPostState> {
  final PostRepo _postRepo;
  final TagSuggestionService _tagSuggestionService;

  AddPostCubit(this._postRepo, this._tagSuggestionService)
      : super(AddPostStateInitial());

  Future<void> addPost(
      String text, List<PostmediaModel> media, String? repostId, bool isPublic,
      {List<TaggedEntity> taggedUsers = const [],
      List<TaggedEntity> taggedCompanies = const []}) async {
    emit(AddPostStateLoading());

    try {
      await _postRepo.addPost(
        text,
        media,
        repostId,
        isPublic,
        taggedUsers: taggedUsers,
        taggedCompanies: taggedCompanies,
      );
      emit(AddPostStateSuccess());
    } catch (e) {
      emit(AddPostStateFailure(e.toString()));
    }
  }

  Future<List<TaggedUser>> getUserSuggestions(String query) async {
    try {
      return await _tagSuggestionService.getUserSuggestions(query);
    } catch (e) {
      print('Error getting user suggestions: $e');
      return [];
    }
  }

  Future<List<TaggedCompany>> getCompanySuggestions(String query) async {
    try {
      return await _tagSuggestionService.getCompanySuggestions(query);
    } catch (e) {
      print('Error getting company suggestions: $e');
      return [];
    }
  }
}
