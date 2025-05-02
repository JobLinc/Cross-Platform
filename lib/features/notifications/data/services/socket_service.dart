import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/notifications/data/models/notification_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;
  final String _baseUrl;
  bool _isConnected = false;
  final Function(NotificationModel) onNewNotification;
  final AuthService _authService = getIt<AuthService>();
  Timer? _reconnectTimer;

  SocketService({
    required String baseUrl,
    required this.onNewNotification,
  }) : _baseUrl = baseUrl;

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_socket != null) {
      _socket!.disconnect();
    }

    try {
      String? token = await _authService.getAccessToken();

      if (token == null) {
        debugPrint('Socket: Cannot connect - No authentication token');
        return;
      }

      // Connect to the notification namespace
      _socket = IO.io(
        '$_baseUrl/notification',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNew()
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .build(),
      );

      _setupSocketListeners();
      _socket!.connect();
    } catch (e) {
      debugPrint('Socket: Error connecting: $e');
      _scheduleReconnect();
    }
  }

  void _setupSocketListeners() {
    _socket!.onConnect((_) {
      debugPrint('Socket: Connected to notification namespace ');
      _isConnected = true;

      // Cancel any pending reconnect attempts
      _cancelReconnectTimer();

      // No need to manually join a room - the server automatically maps
      // the user ID to socket ID(s) based on the authentication token
    });

    _socket!.on('newNotification', (data) {
      try {
        debugPrint('Socket: Received notification: $data');
        // The notification payload format should be:
        // {
        //   "type": "react | comment | connection | message",
        //   "text": "string",
        //   "relatedEntityId": "string",
        //   "subRelatedEntityId": "string | null",
        //   "imageURL": "string | null"
        // }
        final newNotification = NotificationModel.fromJson(data);
        onNewNotification(newNotification);
      } catch (e) {
        debugPrint('Socket: Error processing notification: $e');
      }
    });

    _socket!.onDisconnect((_) {
      debugPrint('Socket: Disconnected from notification namespace ');
      _isConnected = false;
      _scheduleReconnect();
    });

    _socket!.onError((data) {
      debugPrint('Socket: Error: $data');
      _scheduleReconnect();
    });

    _socket!.onConnectError((data) {
      debugPrint('Socket: Connect Error: $data');
      _scheduleReconnect();
    });
  }

  void _scheduleReconnect() {
    // Cancel any existing reconnect timer
    _cancelReconnectTimer();

    // Schedule reconnection after 5 seconds
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_isConnected) {
        debugPrint('Socket: Attempting to reconnect...');
        connect();
      }
    });
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void disconnect() {
    _cancelReconnectTimer();
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _isConnected = false;
    debugPrint('Socket: Manually disconnected');
  }
}
