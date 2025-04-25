import 'package:dio/dio.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';

class GetCompanyPostsApiService {
  final Dio dio;

  GetCompanyPostsApiService(this.dio);

  Future<List<PostModel>> getMyCompanyPosts() async {
    try {
      final response = await dio.get(
        '/post/my-posts',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load company posts');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
