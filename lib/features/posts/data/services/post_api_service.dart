import 'package:dio/dio.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';

class PostApiService {
  final Dio _dio;

  PostApiService(this._dio);

  Future<List<PostModel>> getUserPosts(String userid) async {
    try {
      final response = await _dio.get('/post/$userid/posts');
      List<PostModel> posts = [];

      for (Map<String, dynamic> post in response.data) {
        posts.add(PostModel.fromJson(post));
      }

      return posts;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<PostModel>> getMyPosts() async {
    try {
      final response = await _dio.get('/post/my-posts');
      List<PostModel> posts = [];

      for (Map<String, dynamic> post in response.data) {
        posts.add(PostModel.fromJson(post));
      }

      return posts;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

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

  Future<List<PostModel>> getSavedPosts() async {
    try {
      final response = await _dio.get('/post/saved-posts');
      List<PostModel> posts = [];

      for (Map<String, dynamic> post in response.data) {
        posts.add(PostModel.fromJson(post));
      }

      return posts;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> addPost(
    String text,
    List<String> media,
    String? repostId,
    bool isPublic,
  ) async {
    try {
      final response = await _dio.post('/post/add', data: {
        'text': text,
        'media': media.isNotEmpty ? media : null,
        'repost': repostId,
        'isPublic': isPublic,
      });
      return response.data['postId'];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> savePost(String postId) async {
    try {
      final respone = await _dio.post('/post/$postId/save');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> unsavePost(String postId) async {
    try {
      final respone = await _dio.post('/post/$postId/unsave');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> editPost(
    String postId,
    String? text,
    List<String>? attachmentsUrls,
  ) async {
    try {
      final data = {};
      if (text != null) {
        data.addAll({'text': text});
      }
      if (attachmentsUrls != null) {
        data.addAll({'mediaUrl': attachmentsUrls});
      }
      final respone =
          await _dio.post('/post/$postId/edit', data: {}..addAll(data));
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final respone = await _dio.post('/post/$postId/delete');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> reactToPost(String postId, Reactions reaction) async {
    final type = reaction.toString().split('.')[1];
    try {
      final respone = await _dio.post('/post/$postId/react',
          data: {'type': '${type[0].toUpperCase()}${type.substring(1)}'});
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
}
