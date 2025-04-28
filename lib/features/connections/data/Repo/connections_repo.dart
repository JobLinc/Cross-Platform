import 'package:dio/dio.dart';
import 'package:joblinc/features/connections/data/Web_Services/connection_webService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';

class UserConnectionsRepository {
  final UserConnectionsApiService _apiService;

  UserConnectionsRepository(this._apiService);

  Future<List<UserConnection>> getConnections() async {
    try {
      final data = await _apiService.getConnections();

      return data.map((json) => UserConnection.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error mapping users: $e');
    }
  }

  Future<List<UserConnection>> getInvitations() async {
    try {
      final data = await _apiService.getInvitations();
      return data.map((json) => UserConnection.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error mapping invitations: $e');
    }
  }

  Future<List<UserConnection>> getSentInvitations() async {
    try {
      final data = await _apiService.getSentInvitations();
      return data.map((json) => UserConnection.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error mapping sent invitations: $e');
    }
  }

  Future<Response> changeConnectionStatus(String userId, String status) async {
    try {
      return await _apiService.changeConnectionStatus(userId, status);
    } catch (e) {
      print('Repository error changing connection status: $e');
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
      print('Repository error responding to connection: $e');
      rethrow;
    }
  }

  Future<List<UserConnection>> getUserConnections(String userId) async {
    try {
      final data = await _apiService.getUserConnections(userId);

      return data.map((json) => UserConnection.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error mapping user connections: $e');
    }
  }
  Future<List<UserConnection>> getBlockedConnections() async {
  try {
    final data = await _apiService.getBlockedConnections();

    return data.map((json) => UserConnection.fromJson(json)).toList();
  } catch (e) {
    throw Exception('Error mapping blocked users: $e');
  }
}
}
