import 'package:dio/dio.dart';
import 'package:joblinc/features/home/data/models/post_model.dart';

class PostApiService {
  final Dio _dio;

  PostApiService(this._dio);

  Future<PostModel> getPost(String postID) async {
    try {
      final response = await _dio.get(
        '/post/$postID',
      );
      return PostModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        return 'unauthorized';
      } else {
        return 'internal Server error';
      }
    } else {
      return 'Network error: ${e.message}';
    }
  }

  Future<List<PostModel>> getFeed(int amount) async {
    try {
      final response = await _dio.get('/feed/$amount');
      List<PostModel> posts = List.empty();

      for (Map<String, dynamic> post in response.data['posts']) {
        posts.add(PostModel.fromJson(post));
      }

      return posts;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }
}
