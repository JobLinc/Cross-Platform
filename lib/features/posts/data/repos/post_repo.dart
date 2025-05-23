import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/data/services/post_api_service.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/posts/data/models/reaction_model.dart';
import 'package:joblinc/features/userprofile/data/service/my_user_profile_api.dart';

class PostRepo {
  final PostApiService _postApiService;
  final UserProfileApiService _userProfileApiService;

  PostRepo(this._postApiService, this._userProfileApiService);

  Future<List<ReactionModel>> getPostReactions(String postId) async {
    return await _postApiService.getPostReactions(postId);
  }

  Future<PostmediaModel> uploadImage(XFile image) async {
    return await _postApiService.uploadImage(image);
  }

  Future<void> reportPost(String postId) async {
    return await _postApiService.reportPost(postId);
  }

  Future<List<PostModel>> getUserPosts(String userId) async {
    return await _postApiService.getUserPosts(userId);
  }

  Future<List<PostModel>> getMyPosts() async {
    return await _postApiService.getMyPosts();
  }

  Future<PostModel> getPost(String postID) async {
    return await _postApiService.getPost(postID);
  }

  Future<List<PostModel>> getFeed({int? start, int? end}) async {
    return await _postApiService.getFeed(start, end);
  }

  Future<String> addPost(
    String text,
    List<PostmediaModel> media,
    String? repostId,
    bool isPublic, {
    List<TaggedEntity> taggedUsers = const [],
    List<TaggedEntity> taggedCompanies = const [],
  }) async {
    return await _postApiService.addPost(
      text,
      media,
      repostId,
      isPublic,
      taggedUsers: taggedUsers,
      taggedCompanies: taggedCompanies,
    );
  }

  Future<UserProfile> getUserInfo() async {
    return await _userProfileApiService.getUserProfile();
  }

  Future<List<PostModel>> getSavedPosts() async {
    return await _postApiService.getSavedPosts();
  }

  Future<void> savePost(String postId) async {
    await _postApiService.savePost(postId);
  }

  Future<void> unsavePost(String postId) async {
    await _postApiService.unsavePost(postId);
  }

  Future<void> editPost(
      String postId, String? text, List<PostmediaModel>? mediaItems,
      {List<TaggedEntity> taggedUsers = const [],
      List<TaggedEntity> taggedCompanies = const []}) async {
    await _postApiService.editPost(
      postId,
      text,
      mediaItems,
      taggedUsers: taggedUsers,
      taggedCompanies: taggedCompanies,
    );
  }

  Future<void> deletePost(String postId) async {
    await _postApiService.deletePost(postId);
  }

  Future<void> reactToPost(String postId, Reactions reaction) async {
    await _postApiService.reactToPost(postId, reaction);
  }

  Future<List<PostModel>> searchPosts(String searchText,
      {int? start, int? end}) async {
    return await _postApiService.searchPosts(searchText,
        start: start, end: end);
  }
}
