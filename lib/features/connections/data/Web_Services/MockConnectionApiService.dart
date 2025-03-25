import 'package:dio/dio.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/data/models/pendingconnectionsdemomodel.dart';
import 'package:joblinc/features/connections/data/models/sentconnectionsmodel.dart';

class MockConnectionApiService {
  final Dio dio = Dio();

  Future<Response> getConnections() async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      requestOptions: RequestOptions(path: '/connections'),
      statusCode: 200,
      data: mockConnections.map((connection) => connection.toJson()).toList(),
    );
  }

  Future<Response> getPendingInvitations() async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      requestOptions: RequestOptions(path: '/pending-invitations'),
      statusCode: 200,
      data: mockPendingInvitations
          .map((invitation) => invitation.toJson())
          .toList(),
    );
  }

  Future<Response> getSentConnections() async {
    await Future.delayed(const Duration(seconds: 1));

    return Response(
      requestOptions: RequestOptions(path: '/sent-connections'),
      statusCode: 200,
      data:
          mockSentConnections.map((connection) => connection.toJson()).toList(),
    );
  }

  Future<Response> addConnection(UserConnection connection) async {
    await Future.delayed(const Duration(seconds: 0));

    mockConnections.add(connection);

    return Response(
      requestOptions: RequestOptions(path: '/connections/add'),
      statusCode: 201,
      data: {
        "status": "success",
        "message": "Connection added successfully",
        "data": connection.toJson(),
      },
    );
  }

  Future<Response> removeConnection(String userId) async {
    await Future.delayed(const Duration(seconds: 0));

    final index = mockConnections.indexWhere((c) => c.userId == userId);
    if (index != -1) {
      mockConnections.removeAt(index);
      return Response(
        requestOptions: RequestOptions(path: '/connections/remove'),
        statusCode: 200,
        data: {
          "status": "success",
          "message": "Connection removed successfully",
        },
      );
    } else {
      return Response(
        requestOptions: RequestOptions(path: '/connections/remove'),
        statusCode: 404,
        data: {
          "status": "error",
          "message": "Connection not found",
        },
      );
    }
  }

  Future<Response> removePendingInvitation(String userId) async {
    await Future.delayed(const Duration(seconds: 0));

    final index = mockPendingInvitations.indexWhere((c) => c.userId == userId);
    if (index != -1) {
      mockPendingInvitations.removeAt(index);
      return Response(
        requestOptions: RequestOptions(path: '/pending-invitations/remove'),
        statusCode: 200,
        data: {
          "status": "success",
          "message": "Pending invitation removed successfully",
        },
      );
    } else {
      return Response(
        requestOptions: RequestOptions(path: '/pending-invitations/remove'),
        statusCode: 404,
        data: {
          "status": "error",
          "message": "Pending invitation not found",
        },
      );
    }
  }

  Future<Response> removeSentConnection(String userId) async {
    await Future.delayed(const Duration(seconds: 0));

    final index = mockSentConnections.indexWhere((c) => c.userId == userId);
    if (index != -1) {
      mockSentConnections.removeAt(index);
      return Response(
        requestOptions: RequestOptions(path: '/sent-connections/remove'),
        statusCode: 200,
        data: {
          "status": "success",
          "message": "Sent connection removed successfully",
        },
      );
    } else {
      return Response(
        requestOptions: RequestOptions(path: '/sent-connections/remove'),
        statusCode: 404,
        data: {
          "status": "error",
          "message": "Sent connection not found",
        },
      );
    }
  }
}
