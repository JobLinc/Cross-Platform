import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/logic/cubit/focus_post_state.dart';

class FocusPostCubit extends Cubit<FocusPostState> {
  final PostRepo _postRepo;
  
  FocusPostCubit(this._postRepo) : super(FocusPostInitial());
  
  Future<void> loadPost(String postId) async {
    emit(FocusPostLoading());
    
    try {
      final post = await _postRepo.getPost(postId);
      emit(FocusPostLoaded(post));
    } catch (e) {
      emit(FocusPostError(e.toString()));
    }
  }
}
