import 'package:dio/dio.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';

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

  Future<List<PostModel>> getFeed(int? start, int? end) async {
    try {
      final response = await _dio.get('/post/feed');
      List<PostModel> posts = [];

      for (Map<String, dynamic> post in response.data) {
        posts.add(PostModel.fromJson(post));
      }

      return posts;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> addPost(String text) async {
    try {
      final response = await _dio.post('/post/add', data: {
        'text': text,
      });
      return response.data['postId'];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // Future<bool> likePost(String postID) async {
  //   try {
  //     final response = await _dio.post('/post/')
  //   }
  // }

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
}
