import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  late IO.Socket socket;

  ChatSocketService() {
    // You can obtain the base URL from your DI container if needed.
    socket = IO.io("http://localhost", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
  }

  void connect() {
    socket.connect();
    socket.onConnect((_) {
      //print("Connected to chat socket");
    });
  

    // Receive a new message from the server
    socket.on("receiveMessage", (data) {
      //print("Message received: $data");
      // Handle recieving message in UI 

    });

    // When a user is typing
    socket.on("messageTyping", (data) {
      //print("User typing: $data");
      // Handle typing indicator in UI.
    });

    // When a user stops typing
    socket.on("stopTyping", (data) {
      //print("User stopped typing: $data");
      // Hide typing indicator in UI.
    });

    // When a message is marked as read
    socket.on("messageRead", (data) {
      //print("Message read: $data");
      // Update UI accordingly.
    });
  }

  void disconnect() {
    socket.disconnect();
  }

  // Send a message (you can include an acknowledgment callback if needed)
  // void sendMessage(Map<String, dynamic> message, [Function? ack]) {
  //   socket.emit("sendMessage", message, ack);
  // }

  // Open a chat by joining a room (for two users)
  void openChat(String chatId, String userId) {
    socket.emit("openChat", [chatId, userId]);
  }

  // Leave a chat room
  void leaveChat(String chatId) {
    socket.emit("leaveChat", chatId);
  }

  // Emit a typing event
  void typing(String chatId, String userId) {
    socket.emit("messageTyping", [chatId, userId]);
  }

  // Emit a stop typing event
  void stopTyping(String chatId, String userId) {
    socket.emit("stopTyping", [chatId, userId]);
  }
}
