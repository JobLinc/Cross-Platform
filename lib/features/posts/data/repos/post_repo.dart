import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/services/post_api_service.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/data/service/my_user_profile_api.dart';

class PostRepo {
  final PostApiService _postApiService;
  final UserProfileApiService _userProfileApiService;

  PostRepo(this._postApiService, this._userProfileApiService);

  Future<PostModel> getPost(String postID) async {
    return await _postApiService.getPost(postID);
  }

  Future<List<PostModel>> getFeed(int amount) async {
    return await _postApiService.getFeed(amount);
  }

  Future<String> addPost(String text) async {
    return await _postApiService.addPost(text);
  }

  Future<UserProfile> getUserInfo() async {
    return await _userProfileApiService.getUserProfile();
  }
}
