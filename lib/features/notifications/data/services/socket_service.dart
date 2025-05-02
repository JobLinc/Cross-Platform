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

      debugPrint('Socket: Trying to connect to $_baseUrl/notification');
      
      // Create socket with proper error handling
      _socket = IO.io('$_baseUrl/notification', <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
        'auth': {
          'authorization': 'Bearer $token',
        }
      });

      // Setup listeners before connecting
      _setupSocketListeners();
      
      // Connect after listeners are set up
      _socket!.connect();
      debugPrint('Socket: Connect called');
    } catch (e) {
      debugPrint('Socket: Error connecting: $e');
      _scheduleReconnect();
    }
  }

  void _setupSocketListeners() {
    // Make sure to remove any existing listeners if reconnecting
    _socket!.off('connect');
    _socket!.off('newNotification');
    _socket!.off('disconnect');
    _socket!.off('error');
    _socket!.off('connect_error');
    
    _socket!.onConnect((_) {
      debugPrint('Socket: Connected to notification namespace ✅');
      _isConnected = true;
      _cancelReconnectTimer();
    });

    _socket!.on('newNotification', (data) {
      try {
        debugPrint('Socket: Received NEW notification: ${data.toString()}');
        final newNotification = NotificationModel.fromJson(data);
        debugPrint('Socket: Processed notification ID: ${newNotification.id}');
        onNewNotification(newNotification);
      } catch (e) {
        debugPrint('Socket: Error processing notification: $e');
        debugPrint('Socket: Raw notification data: $data');
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
    _isConnected = false;
    
    if (_socket != null) {
      try {
        debugPrint('Socket: Disconnecting...');
        // Remove all listeners first to prevent callbacks after disconnection
        _socket!.off('newNotification');
        _socket!.off('connect');
        _socket!.off('disconnect');
        _socket!.off('error');
        _socket!.off('connect_error');
        
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
        debugPrint('Socket: Manually disconnected');
      } catch (e) {
        debugPrint('Socket: Error during disconnect: $e');
      }
    }
  }
}
