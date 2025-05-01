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
    }  on DioException catch (e) {
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

  Future<List<dynamic>> getFollowing() async {
    try {
      final response = await _dio.get('/follow/following');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load follows');
      }
    }  on DioException catch (e) {
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

  Future<List<dynamic>> getFollowers() async {
    try {
      final response = await _dio.get('/follow/followers');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load follows');
      }
    }  on DioException catch (e) {
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

  Future<List<dynamic>> getInvitations() async {
    try {
      final response = await _dio.get('/connection/received');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("error ");
        throw Exception('Failed to load invitations');
      }
    }  on DioException catch (e) {
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

  Future<List<dynamic>> getSentInvitations() async {
    try {
      final response = await _dio.get('/connection/sent');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("error ");
        throw Exception('Failed to load sent invitations');
      }
    }  on DioException catch (e) {
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

  Future<Response> changeConnectionStatus(String userId, String status) async {
    try {
      final response = await _dio.post(
        '/connection/$userId/change',
        data: {'status': status},
      );
      return response;
    }  on DioException catch (e) {
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

  Future<Response> respondToConnection(String userId, String status) async {

    try {
      final response = await _dio.post(
        '/connection/$userId/respond',
        data: {'status': status},
      );
      return response;
    }  on DioException catch (e) {
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

  Future<Response> sendConnection(String userId) async {
    try {
      final response = await _dio.post(
        '/connection/$userId',
      );
      return response;
    }  on DioException catch (e) {
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

  Future<Response> unfollowConnection(String userId) async {
    try {
      final response = await _dio.post(
        '/follow/$userId/unfollow',
      );
      return response;
    }  on DioException catch (e) {
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

  Future<List<dynamic>> getUserConnections(String userId) async {
    try {
      final response = await _dio.get('/connection/$userId/all');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load user connections');
      }
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

  Future<List<dynamic>> getBlockedConnections() async {
    try {
      final response = await _dio.get('/connection/blocked');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load blocked users');
      }
    }  on DioException catch (e) {
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
