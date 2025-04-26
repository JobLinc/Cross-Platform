import 'package:dio/dio.dart';

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
    throw ArgumentError('Invalid status. Must be either "Accepted" or "Rejected".');
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
}
