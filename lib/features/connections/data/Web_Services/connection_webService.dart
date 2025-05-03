import 'package:dio/dio.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

class UserConnectionsApiService {
  final Dio _dio;

  UserConnectionsApiService(this._dio);

  Future<List<dynamic>> getConnections() async {
    try {
      final response = await _dio.get('/connection/connected');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<List<dynamic>> getFollowing() async {
    try {
      final response = await _dio.get('/follow/following');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load follows');
      }
    } catch (e) {
      throw Exception('Error fetching follows: $e');
    }
  }

  Future<List<dynamic>> getFollowers() async {
    try {
      final response = await _dio.get('/follow/followers');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load follows');
      }
    } catch (e) {
      throw Exception('Error fetching follows: $e');
    }
  }

  Future<List<dynamic>> getInvitations() async {
    try {
      final response = await _dio.get('/connection/received');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("error ");
        throw Exception('Failed to load invitations');
      }
    } catch (e) {
      print("error ${e.toString()}");
      throw Exception('Error fetching invitations: $e');
    }
  }

  Future<List<dynamic>> getSentInvitations() async {
    try {
      final response = await _dio.get('/connection/sent');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("error ");
        throw Exception('Failed to load sent invitations');
      }
    } catch (e) {
      print("error ${e.toString()}");
      throw Exception('Error fetching sent invitations: $e');
    }
  }

  Future<Response> changeConnectionStatus(String userId, String status) async {
    try {
      final response = await _dio.post(
        '/connection/$userId/change',
        data: {'status': status},
      );
      return response;
    } catch (e) {
      print('API error changing connection status: $e');
      rethrow;
    }
  }

  Future<Response> respondToConnection(String userId, String status) async {
    if (status != 'Accepted' && status != 'Rejected') {
      throw ArgumentError(
          'Invalid status. Must be either "Accepted" or "Rejected".');
    }

    try {
      final response = await _dio.post(
        '/connection/$userId/respond',
        data: {'status': status},
      );
      return response;
    } catch (e) {
      print('API error responding to connection: $e');
      rethrow;
    }
  }

  Future<Response> sendConnection(String userId) async {
    try {
      final response = await _dio.post(
        '/connection/$userId',
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> createchat(String userId) async {
    try {
      print("myuserId is ${userId}");
      final response = await _dio.post('/chat/create', data: {
        "receiverIds": [userId]
      });
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> followConnection(String userId) async {
    try {
      final response = await _dio.post(
        '/follow/$userId',
      );
      return response;
    } catch (e) {
      print('API error sending follow request: $e');
      rethrow;
    }
  }

  Future<Response> unfollowConnection(String userId) async {
    try {
      final response = await _dio.post(
        '/follow/$userId/unfollow',
      );
      return response;
    } catch (e) {
      print('API error sending follow request: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getUserConnections(String userId) async {
    try {
      final response = await _dio.get('/connection/$userId/all');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load user connections');
      }
    } catch (e) {
      throw Exception('Error fetching user connections: $e');
    }
  }

  Future<List<dynamic>> getBlockedConnections() async {
    try {
      final response = await _dio.get('/connection/blocked');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load blocked users');
      }
    } catch (e) {
      throw Exception('Error fetching blocked users: $e');
    }
  }

  Future<List<UserProfile>> searchUsers(String query) async {
    try {
      final response = await _dio.get('/user/search', queryParameters: {
        'keyword': query,
      });

      final List data = response.data as List;
      return data.map((json) => UserProfile.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }
}
