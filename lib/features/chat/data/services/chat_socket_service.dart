// import 'package:joblinc/core/di/dependency_injection.dart';
// import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'dart:async';
// import 'dart:io';
// import 'dart:convert';

// class ChatSocketService {
//   late IO.Socket socket;
//   String accessToken;
//   String userId;
//   bool isInitialized = false;
//   bool isConnecting = false;

//   // Match the same approach as the frontend
//   static String getServerUrl() {
//     if (Platform.isAndroid) {
//       return 'http://10.0.2.2:3000'; // Android emulator
//     } else if (Platform.isIOS) {
//       return 'http://localhost:3000'; // iOS simulator
//     } else {
//       return 'http://localhost:3000'; // Default fallback
//     }
//   }

//   static final ChatSocketService _instance =
//       ChatSocketService._internal('', '');

//   factory ChatSocketService(String userId, String accessToken) {
//     _instance.accessToken = accessToken;
//     _instance.userId = userId;
//     if (!_instance.isInitialized && !_instance.isConnecting) {
//       _instance.initialize();
//     }
//     return _instance;
//   }

//   ChatSocketService._internal(this.userId, this.accessToken);

//   AuthService authService = getIt<AuthService>();
//   Future<bool> initialize() async {
//     if (isInitialized || isConnecting) return isInitialized;

//     isConnecting = true;
//     String serverUrl = getServerUrl();
//     print(
//         '🔄 Initializing socket connection to $serverUrl with userId: $userId');

//     try {
//       // Match frontend socket configuration
//       socket = IO.io('$serverUrl/chat', <String, dynamic>{
//         'transports': ['websocket', 'polling'],
//         'autoConnect': false,
//         'reconnection': true,
//         'reconnectionAttempts': 5,
//         'reconnectionDelay': 2000,
//         'auth': {
//           'authorization':
//               'Bearer $accessToken', // Match how the frontend passes auth
//         }
//       });

//       // Set up connection handlers
//       _setupEventHandlers();

//       // Connect socket
//       socket.connect();

//       // Wait for connection or timeout
//       return await _waitForConnection();
//     } catch (e) {
//       print('🔴 Error initializing socket: $e');
//       isConnecting = false;
//       return false;
//     }
//   }

//   void _setupEventHandlers() {
//     socket.onConnect((_) {
//       print('✅ Socket connected successfully (id=${socket.id})');
//       isInitialized = true;
//       isConnecting = false;
//     });

//     socket.onConnectError((error) {
//       print('⚠️ Socket connection error: $error');
//       isConnecting = false;
//     });

//     socket.onDisconnect((reason) {
//       print('❌ Socket disconnected: $reason');
//       isInitialized = false;
//       isConnecting = false;
//     });

//     // Debug all events
//     socket.onAny((event, data) {
//       print(
//           '🔍 Socket event: $event → ${data != null ? jsonEncode(data) : "null"}');
//     });
//   }

//   Future<bool> _waitForConnection() async {
//     Completer<bool> completer = Completer<bool>();

//     // Set timeout for connection
//     Timer timer = Timer(Duration(seconds: 10), () {
//       if (!completer.isCompleted) {
//         print('⏱️ Connection timeout after 10 seconds');
//         completer.complete(false);
//       }
//     });

//     // Listen for successful connection
//     socket.once('connect', (_) {
//       if (!completer.isCompleted) {
//         timer.cancel();
//         completer.complete(true);
//       }
//     });

//     // Listen for connection error
//     socket.once('connect_error', (error) {
//       if (!completer.isCompleted) {
//         timer.cancel();
//         completer.complete(false);
//       }
//     });

//     return completer.future;
//   }

//   void disconnect() {
//     if (isInitialized) {
//       socket.disconnect();
//       isInitialized = false;
//     }
//   }

//   Future<bool> ensureConnection() async {
//     if (isInitialized) return true;
//     if (isConnecting) {
//       // Wait a bit to see if connection completes
//       await Future.delayed(Duration(seconds: 2));
//       return isInitialized;
//     }
//     return await initialize();
//   }

//   // Match frontend implementation - simple emit, no ack waiting
//   void openChat(String chatId) async {
//     bool connected = await ensureConnection();
//     if (connected) {
//       print('🔔 Joining chat room: $chatId');
//       socket.emit('openChat', chatId);
//     }
//   }

//   void leaveChat(String chatId) {
//     if (isInitialized) {
//       socket.emit('leaveChat', chatId);
//     }
//   }

//   // Match frontend approach - simple emit, callback optional
//   void sendMessage(String chatId, String text) async {
//     bool connected = await ensureConnection();
//     if (!connected) {
//       print('⚠️ Cannot send message: Socket not connected');
//       return;
//     }

//     // Match the frontend payload structure exactly
//     final payload = {
//       'content': {'text': text},
//       'chatId': chatId,
//     };

//     print('📤 Sending message: ${jsonEncode(payload)}');

//     socket.emitWithAckAsync('sendMessage', payload, ack: () {
//       print('✅ Message sent successfully');
//     });
//   }

//   // Similar pattern for file messages
//   void sendFileMessage(String chatId, String filePath, String fileType) async {
//     bool connected = await ensureConnection();
//     if (!connected) {
//       print('⚠️ Cannot send file: Socket not connected');
//       return;
//     }

//     Map<String, dynamic> content = {};
//     switch (fileType) {
//       case 'image':
//         content = {'image': filePath};
//         break;
//       case 'video':
//         content = {'video': filePath};
//         break;
//       case 'document':
//       default:
//         content = {'document': filePath};
//     }

//     final payload = {
//       'content': content,
//       'chatId': chatId,
//     };

//     print('📤 Sending $fileType: ${jsonEncode(payload)}');
//     socket.emit('sendMessage', payload);
//   }

//   // Match frontend typing implementations
//   void startTyping(String chatId) async {
//     bool connected = await ensureConnection();
//     if (connected) {
//       socket.emit('messageTyping', chatId);
//     }
//   }

//   void stopTyping(String chatId) async {
//     bool connected = await ensureConnection();
//     if (connected) {
//       socket.emit('stopTyping', chatId);
//     }
//   }

//   void markAsRead(String chatId) async {
//     bool connected = await ensureConnection();
//     if (connected) {
//       await socket.emitWithAckAsync('messageReceived', chatId, ack: () {
//         print('✅ Marked as read successfully');
//       });
//     } else {
//       print('⚠️ Cannot mark as read: Socket not connected');
//     }
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
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
  static String getServerUrl() {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    if (Platform.isIOS)     return 'http://localhost:3000';
    return 'http://localhost:3000';
  }

  // ─── Initialize (connect) only once ────────────────────────────────────────
  Future<bool> initialize({
    required String userId,
    required String accessToken,
  }) async {
    if (_isInitialized || _isConnecting) return _isInitialized;

    _isConnecting = true;
    _userId = userId;
    _accessToken = accessToken;

    final url = getServerUrl();
    print('🔄 Connecting socket to $url/chat as user $_userId');

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
      print('🔴 Socket init error: $e');
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
        print('⏱️ Socket connect timeout');
        completer.complete(false);
      }
    });

    _socket.once('connect', (_) {
      cleanUp();
      print('✅ Socket connected (id=${_socket.id})');
      completer.complete(true);
    });

    _socket.once('connect_error', (err) {
      cleanUp();
      print('⚠️ Socket connect_error: $err');
      completer.complete(false);
    });

    return completer.future;
  }

  // ─── Core event wiring ────────────────────────────────────────────────────
  void _setupEventHandlers() {
    _socket.onConnect((_) {
      // nothing— handled by _waitForConnection
    });

    _socket.onDisconnect((reason) {
      print('❌ Socket disconnected: $reason');
      _isInitialized = false;
    });

    // _socket.onError(handlers: (error) {
    //   print('⚠️ Socket error: $error');
    // });
    _socket.on('error', (error) {
      print('⚠️ Socket  bbbbb error: $error');
      onErrorReceived?.call(Map<String, dynamic>.from(error));
    });

    // Debug all other events
    _socket.onAny((event, data) {
      print('🔍 [socket event] $event → ${data != null ? jsonEncode(data) : 'null'}');
    });

    // Domain events:
    _socket.on('receiveMessage', (data) {
      print('📥 Message received: ${jsonEncode(data)}');
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
    if (data is Map && data['chatId'] is String) return data['chatId'] as String;
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
    final payload = {'content': {'text': text}, 'chatId': chatId};
    print('📤 sendMessage → $payload');
    _socket.emitWithAckAsync('sendMessage', payload, ack: () {
      print('✅ sendMessage ack');
    });
  }

  void sendFileMessage(String chatId, String filePath, String fileType) {
    if (!_isInitialized) return;
    Map<String, dynamic> content;
    switch (fileType) {
      case 'image':    content = {'image': filePath}; break;
      case 'video':    content = {'video': filePath}; break;
      default:         content = {'document': filePath};
    }
    final payload = {'content': content, 'chatId': chatId};
    print('📤 sendFileMessage → $payload');
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
    _socket.emitWithAckAsync('messageReceived', chatId, ack: () {
      print('✅ markAsRead ack');
    });
  }

  void disconnect() {
    if (_isInitialized) {
      _socket.disconnect();
      _isInitialized = false;
    }
  }
}
