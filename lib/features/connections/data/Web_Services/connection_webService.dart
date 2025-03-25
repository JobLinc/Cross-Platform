import 'package:dio/dio.dart';

class UserConnectionsApiService {
  final Dio _dio;

  UserConnectionsApiService(this._dio);

  Future<List<dynamic>> getConnections() async {
    try {
      final response =
          await _dio.get('/connections/connected');
      if (response.statusCode == 200) {
        return response
            .data; 
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
  Future<List<dynamic>> getInvitations() async {
    try {
      final response = await _dio.get('/connections/received'); 
      if (response.statusCode == 200) {
        return response.data; 
      } else {
        throw Exception('Failed to load invitations');
      }
    } catch (e) {
      throw Exception('Error fetching invitations: $e');
    }
  }
}
