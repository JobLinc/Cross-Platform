import 'package:joblinc/features/posts/data/models/post_model.dart';
import '../services/getcompanyposts_api_service.dart';

class GetCompanyPostsRepo {
  final GetCompanyPostsApiService apiService;

  GetCompanyPostsRepo(this.apiService);

  Future<List<PostModel>> getMyCompanyPosts() {
    return apiService.getMyCompanyPosts();
  }
}
