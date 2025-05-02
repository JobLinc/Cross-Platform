import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/home/logic/cubit/home_state.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

class HomeCubit extends Cubit<HomeState> {
  final PostRepo _postRepo;
  
  // Keep track of the current state of posts and user separately
  List<PostModel>? _currentPosts;
  bool _postsLoading = false;
  String? _postsError;
  
  UserProfile? _currentUser;
  bool _userLoading = false;
  String? _userError;

  HomeCubit(this._postRepo) : super(HomeInitial());

  // Method to get combined state for UI
  HomeCombinedState get combinedState => HomeCombinedState(
    posts: _currentPosts,
    postsLoading: _postsLoading,
    postsError: _postsError,
    user: _currentUser,
    userLoading: _userLoading,
    userError: _userError,
  );

  // Load posts and user profile independently
  Future<void> loadHomeData() async {
    loadPosts();
    loadUserProfile();
  }

  // Load only posts
  Future<void> loadPosts({int? start, int? end}) async {
    // Update internal state
    _postsLoading = true;
    _postsError = null;
    // Emit loading state
    emit(HomePostsLoading());

    try {
      final posts = await _postRepo.getFeed(start: start, end: end);
      // Update internal state
      _currentPosts = posts;
      _postsLoading = false;
      // Emit success state
      emit(HomePostsLoaded(posts));
    } catch (e) {
      // Update internal state
      _postsLoading = false;
      _postsError = e.toString();
      // Emit failure state
      emit(HomePostsFailure(e.toString()));
    }
  }

  // Load only user profile
  Future<void> loadUserProfile() async {
    // Update internal state
    _userLoading = true;
    _userError = null;
    // Emit loading state
    emit(HomeUserLoading());

    try {
      final user = await _postRepo.getUserInfo();
      // Update internal state
      _currentUser = user;
      _userLoading = false;
      // Emit success state
      emit(HomeUserLoaded(user));
    } catch (e) {
      // Update internal state
      _userLoading = false;
      _userError = e.toString();
      // Emit failure state
      emit(HomeUserFailure(e.toString()));
    }
  }

  // Legacy method for backward compatibility
  Future<void> getFeed({int? start, int? end}) async {
    loadHomeData();
  }
}


