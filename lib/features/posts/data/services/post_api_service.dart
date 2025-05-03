import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joblinc/features/posts/data/models/post_media_model.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/data/models/reaction_model.dart';
import 'package:joblinc/features/posts/logic/reactions.dart';

class PostApiService {
  final Dio _dio;

  PostApiService(this._dio);

  Future<List<ReactionModel>> getPostReactions(String postId) async {
    try {
      final response = await _dio.get('/post/$postId/reactions');
      List<ReactionModel> reactions = [];

      for (Map<String, dynamic> reaction in response.data) {
        reactions.add(ReactionModel.fromJson(reaction));
      }

      return reactions;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

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
    String text,
    List<PostmediaModel> media,
    String? repostId,
    bool isPublic,
  ) async {
    try {
      List<Map> mediaList = [];
      for (PostmediaModel postmedia in media) {
        String typeString = postmedia.mediaType.toString().split('.').last;
        mediaList.add({
          'url': postmedia.url,
          'type': '${typeString[0].toUpperCase()}${typeString.substring(1)}',
        });
      }
      final response = await _dio.post('/post/add', data: {
        'text': text,
        'media': media.isNotEmpty ? mediaList : null,
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
      final response = await _dio.post('/post/$postId/save');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> unsavePost(String postId) async {
    try {
      final response = await _dio.post('/post/$postId/unsave');
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
      final response =
          await _dio.post('/post/$postId/edit', data: {}..addAll(data));
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final response = await _dio.post('/post/$postId/delete');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<PostmediaModel> uploadImage(XFile file) async {
    return await _uploadMedia(file, 'Image');
  }

  Future<PostmediaModel> uploadVideo(XFile file) async {
    return await _uploadMedia(file, 'Video');
  }

  Future<PostmediaModel> uploadDocument(XFile file) async {
    return await _uploadMedia(file, 'Document');
  }

  Future<PostmediaModel> uploadAudio(XFile file) async {
    return await _uploadMedia(file, 'Audio');
  }

  Future<PostmediaModel> _uploadMedia(XFile file, String type) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: getMediaType(file),
      ),
      'type': type,
    });
    try {
      final response = await _dio.post(
        '/post/upload-media',
        data: formData,
      );
      return PostmediaModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> reactToPost(String postId, Reactions reaction) async {
    final type = reaction.toString().split('.')[1];
    try {
      final response = await _dio.post('/post/$postId/react',
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

MediaType getMediaType(XFile file) {
  final extension = file.path.split('.').last.toLowerCase();

  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return MediaType('image', 'jpeg');
    case 'png':
      return MediaType('image', 'png');
    case 'gif':
      return MediaType('image', 'gif');
    default:
      return MediaType('application', 'octet-stream'); // Fallback
  }
}
