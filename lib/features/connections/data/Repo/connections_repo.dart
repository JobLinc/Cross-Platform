import 'package:dio/dio.dart';
import 'package:joblinc/features/connections/data/Web_Services/connection_webService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/userprofile/data/models/follow_model.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

class UserConnectionsRepository {
  final UserConnectionsApiService _apiService;

  UserConnectionsRepository(this._apiService);

  Future<List<UserConnection>> getConnections() async {
    try {
      final data = await _apiService.getConnections();

      return data.map((json) => UserConnection.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Follow>> getFollowing() async {
    try {
      final data = await _apiService.getFollowing();

      return data.map((json) => Follow.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Follow>> getFollowers() async {
    try {
      final data = await _apiService.getFollowers();

      return data.map((json) => Follow.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserConnection>> getInvitations() async {
    try {
      final data = await _apiService.getInvitations();
      return data.map((json) => UserConnection.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserConnection>> getSentInvitations() async {
    try {
      final data = await _apiService.getSentInvitations();
      return data.map((json) => UserConnection.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> changeConnectionStatus(String userId, String status) async {
    try {
      return await _apiService.changeConnectionStatus(userId, status);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> respondToConnection(String userId, String status) async {
    try {
      return await _apiService.respondToConnection(userId, status);
    } catch (e) {
      print('Repository error responding to connection: $e');
      rethrow;
    }
  }

  Future<Response> sendConnection(String userId) async {
    try {
      return await _apiService.sendConnection(userId);
    } catch (e) {
      print('Repository error requesting connection: $e');
      rethrow;
    }
  }

  Future<Response> follwConnection(String userId) async {
    try {
      return await _apiService.followConnection(userId);
    } catch (e) {
      print('Repository error following connection: $e');
      rethrow;
    }
  }

  Future<Response> unfollwConnection(String userId) async {
    try {
      return await _apiService.unfollowConnection(userId);
    } catch (e) {
      print('Repository error unfollowing connection: $e');
      rethrow;
    }
  }

  Future<List<UserConnection>> getUserConnections(String userId) async {
    try {
      final data = await _apiService.getUserConnections(userId);

      return data.map((json) => UserConnection.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserConnection>> getBlockedConnections() async {
    try {
      final data = await _apiService.getBlockedConnections();

      return data.map((json) => UserConnection.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createchat(String userId) async {
    try {
      print("REPOOOOOOOOOOOOOOOOOOOO");
      final response = await _apiService.createchat(userId);
      print("${response.data["chatId"]}");
      return response.data["chatId"];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserProfile>> searchUsers(String keyword) {
    try {
      return _apiService.searchUsers(keyword);
    } catch (e) {
      rethrow;
    }
  }
}
