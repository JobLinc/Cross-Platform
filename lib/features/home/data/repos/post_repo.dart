import 'package:joblinc/features/home/data/models/post_model.dart';
import 'package:joblinc/features/home/data/services/post_api_service.dart';

class PostRepo {
  final PostApiService _postApiService;

  PostRepo(this._postApiService);

  Future<PostModel> getPost(String postID) async {
    return await _postApiService.getPost(postID);
  }

  Future<List<PostModel>> getFeed(int amount) async {
    return await _postApiService.getFeed(amount);
  }
}
