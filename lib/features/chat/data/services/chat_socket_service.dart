import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  // ─── Singleton boilerplate ────────────────────────────────────────────────
  ChatSocketService._internal();
  static final ChatSocketService _instance = ChatSocketService._internal();
  static ChatSocketService get instance => _instance;

  // ─── Internal state ────────────────────────────────────────────────────────
  late IO.Socket _socket;
  bool _isInitialized = false;
  bool _isConnecting = false;
  String? _userId;
  String? _accessToken;

  // ─── Callbacks for screens to subscribe ────────────────────────────────────
  void Function(Map<String, dynamic> messageData)? onMessageReceived;
  void Function(Map<String, dynamic> messageData)? onErrorReceived;
  void Function(String chatId)? onTyping;
  void Function(String chatId)? onStopTyping;
  void Function(String readerId)? onReadReceipt;
  void Function(String chatId)? onListTyping;
  void Function(String chatId)? onListStopTyping;
  void Function(Map<String, dynamic> cardData)? onCardUpdate;

  // ─── Public getters ───────────────────────────────────────────────────────
  IO.Socket get socket => _socket;
  bool get isInitialized => _isInitialized;

  // ─── Determine server URL ─────────────────────────────────────────────────
  // ─── Initialize (connect) only once ────────────────────────────────────────

  Future<bool> initialize({
    required String userId,
    required String accessToken,
  }) async {
    if (_isInitialized || _isConnecting) return _isInitialized;

    _isConnecting = true;
    _userId = userId;
    _accessToken = accessToken;

    final url = 'wss://joblinc.me:3000';

    try {
      _socket = IO.io(
        '$url/chat',
        <String, dynamic>{
          'transports': ['websocket', 'polling'],
          'autoConnect': false,
          'reconnection': true,
          'reconnectionAttempts': 5,
          'reconnectionDelay': 2000,
          'auth': {
            'authorization': 'Bearer $_accessToken',
          },
        },
      );

      _setupEventHandlers();
      _socket.connect();

      // wait up to 10s for connect
      final connected = await _waitForConnection();
      _isConnecting = false;
      _isInitialized = connected;
      return connected;
    } catch (e) {
      _isConnecting = false;
      return false;
    }
  }

  Future<bool> _waitForConnection() {
    final completer = Completer<bool>();
    Timer? timer;

    void cleanUp() {
      timer?.cancel();
      _socket.off('connect');
      _socket.off('connect_error');
    }

    timer = Timer(Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    _socket.once('connect', (_) {
      cleanUp();
      completer.complete(true);
    });

    _socket.once('connect_error', (err) {
      cleanUp();
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    return completer.future;
  }

  // ─── Core event wiring ────────────────────────────────────────────────────
  void _setupEventHandlers() {
    _socket.onConnect((_) {
      // nothing— handled by _waitForConnection
    });

    _socket.onDisconnect((reason) {
      _isInitialized = false;
    });

    // _socket.onError(handlers: (error) {
    // });
    _socket.on('error', (error) {
      onErrorReceived?.call(Map<String, dynamic>.from(error));
    });

    // Debug all other events
    _socket.onAny((event, data) {});

    // Domain events:
    _socket.on('receiveMessage', (data) {
      onMessageReceived?.call(Map<String, dynamic>.from(data));
    });

    _socket.on('messageTyping', (data) {
      final chatId = _extractChatId(data);
      if (chatId != null) {
        onTyping?.call(chatId);
        onListTyping?.call(chatId);
      }
    });

    _socket.on('stopTyping', (data) {
      final chatId = _extractChatId(data);
      if (chatId != null) {
        onStopTyping?.call(chatId);
        onListStopTyping?.call(chatId);
      }
    });

    _socket.on('messageRead', (readerId) {
      if (readerId is String) onReadReceipt?.call(readerId);
    });

    _socket.on('cardUpdate', (data) {
      onCardUpdate?.call(Map<String, dynamic>.from(data));
    });
  }

  String? _extractChatId(dynamic data) {
    if (data is String) return data;
    if (data is Map && data['chatId'] is String)
      return data['chatId'] as String;
    return null;
  }

  // ─── Cleanup handlers if screens dispose ─────────────────────────────────
  void clearEventHandlers() {
    onMessageReceived = null;
    onTyping = null;
    onStopTyping = null;
    onReadReceipt = null;
    onListTyping = null;
    onListStopTyping = null;
    onCardUpdate = null;
  }

  // ─── Public socket actions ────────────────────────────────────────────────
  void openChat(String chatId) {
    if (!_isInitialized) return;
    _socket.emit('openChat', chatId);
  }

  void leaveChat(String chatId) {
    if (!_isInitialized) return;
    _socket.emit('leaveChat', chatId);
  }

  void sendMessage(String chatId, String text) {
    if (!_isInitialized) return;
    final payload = {
      'content': {'text': text},
      'chatId': chatId
    };
    _socket.emitWithAckAsync('sendMessage', payload, ack: () {});
  }

  void sendFileMessage(String chatId, String filePath, String fileType) {
    if (!_isInitialized) return;
    Map<String, dynamic> content;
    switch (fileType) {
      case 'image':
        content = {'image': filePath};
        break;
      case 'video':
        content = {'video': filePath};
        break;
      default:
        content = {'document': filePath};
    }
    final payload = {'content': content, 'chatId': chatId};
    _socket.emit('sendMessage', payload);
  }

  void startTyping(String chatId) {
    if (!_isInitialized) return;
    _socket.emit('messageTyping', chatId);
  }

  void stopTyping(String chatId) {
    if (!_isInitialized) return;
    _socket.emit('stopTyping', chatId);
  }

  void markAsRead(String chatId) {
    if (!_isInitialized) return;
    _socket.emitWithAckAsync('messageReceived', chatId, ack: () {});
  }

  void disconnect() {
    if (_isInitialized) {
      _socket.disconnect();
      _isInitialized = false;
    }
  }
}
