import 'package:dio/dio.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';

class PostApiService {
  final Dio _dio;

  PostApiService(this._dio);

  Future<void> reportPost(String postId) async {
    try {
      await _dio.post('/reports/reportPost', data: {
        'reportedId': postId,
      });
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

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
      String text, List<String> media, String? repostId, bool isPublic,
      {List<TaggedEntity> taggedUsers = const [],
      List<TaggedEntity> taggedCompanies = const []}) async {
    try {
      final Map<String, dynamic> data = {
        'text': text,
        'isPublic': isPublic,
      };

      if (media.isNotEmpty) {
        data['media'] = media;
      }

      if (repostId != null) {
        data['repost'] = repostId;
      }

      if (taggedUsers.isNotEmpty) {
        data['taggedUsers'] = taggedUsers.map((user) => user.toJson()).toList();
      }

      if (taggedCompanies.isNotEmpty) {
        data['taggedCompanies'] =
            taggedCompanies.map((company) => company.toJson()).toList();
      }

      final response = await _dio.post('/post/add', data: data);
      print(data);
      print(response.data);
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
      String postId, String? text, List<PostmediaModel>? mediaItems,
      {List<TaggedEntity> taggedUsers = const [],
      List<TaggedEntity> taggedCompanies = const []}) async {
    try {
      final data = {};
      if (text != null) {
        data.addAll({'text': text});
      }

      if (mediaItems != null && mediaItems.isNotEmpty) {
        // Format media items as per API documentation
        final List<Map<String, String>> formattedMedia = mediaItems.map((item) {
          return {
            'url': item.url,
            'type': _getMediaTypeString(item.mediaType),
          };
        }).toList();

        data.addAll({'media': formattedMedia});
      }

      // Add tagged entities if they exist
      if (taggedUsers.isNotEmpty) {
        data['taggedUsers'] = taggedUsers.map((user) => user.toJson()).toList();
      }

      if (taggedCompanies.isNotEmpty) {
        data['taggedCompanies'] =
            taggedCompanies.map((company) => company.toJson()).toList();
      }

      print(data);
      final response = await _dio.post('/post/$postId/edit', data: data);
      print(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  // Helper method to convert MediaType enum to string format expected by API
  String _getMediaTypeString(MediaType type) {
    switch (type) {
      case MediaType.image:
        return 'Image';
      case MediaType.video:
        return 'Video';
      case MediaType.audio:
        return 'Audio';
      case MediaType.document:
        return 'Document';
      default:
        return 'Image';
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

  Future<List<PostModel>> searchPosts(String searchText,
      {int? start, int? end}) async {
    try {
      Map<String, dynamic> queryParams = {'searchText': searchText};
      if (start != null) queryParams['start'] = start.toString();
      if (end != null) queryParams['end'] = end.toString();

      final response =
          await _dio.get('/post/search', queryParameters: queryParams);
      List<PostModel> posts = [];

      for (Map<String, dynamic> post in response.data) {
        posts.add(PostModel.fromJson(post));
      }

      return posts;
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
