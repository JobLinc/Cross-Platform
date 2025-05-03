import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class NewMessage extends StatefulWidget {
  final String chatId;
  final IO.Socket socket;
  final Function onMessageSent;

  const NewMessage({
    super.key,
    required this.chatId,
    required this.socket,
    required this.onMessageSent,
  });

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  bool _isSending = false;
  bool _hasError = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final enteredMessage = _messageController.text.trim();

    if (enteredMessage.isEmpty) {
      return;
    }

    setState(() {
      _isSending = true;
      _hasError = false;
    });

    // Clear the input field immediately for better UX
    final messageToSend = enteredMessage;
    _messageController.clear();

    // Tell the parent widget that a message was sent (for local UI update)
    widget.onMessageSent(messageToSend);

    // Format the message exactly as expected by backend - match frontend
    final payload = {
      'content': {'text': messageToSend},
      'chatId': widget.chatId,
    };

    try {
      // Simple emit without acknowledgment - matching frontend approach
      widget.socket.emit('sendMessage', payload);

      // Mark as sent after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isSending = false;
          });
        }
      });

      // Notify server we stopped typing - simple emit
      widget.socket.emit('stopTyping', widget.chatId);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSending = false;
          _hasError = true;
        });
      }
    }
  }

  void _startTyping() {
    widget.socket.emit('messageTyping', widget.chatId);
  }

  void _stopTyping() {
    widget.socket.emit('stopTyping', widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: _hasError
                ? Colors.red.withOpacity(0.5)
                : Colors.grey.withOpacity(0.2),
            width: 1.0,
            style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.grey[10]),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                hintText: _hasError
                    ? 'Error sending, try again...'
                    : 'Write a message...',
                hintStyle: TextStyle(
                    color: _hasError ? Colors.red[300] : Colors.grey[10]),
                border: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              autocorrect: true,
              cursorColor: Colors.red,
              onChanged: (text) {
                if (_hasError) {
                  setState(() {
                    _hasError = false;
                  });
                }

                if (text.isNotEmpty) {
                  _startTyping();
                } else {
                  _stopTyping();
                }
              },
              onEditingComplete: _stopTyping,
              onSubmitted: (_) => _sendMessage(),
            ),
          )),
          IconButton(
              onPressed: _isSending ? null : _sendMessage,
              icon: _isSending
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ))
                  : Icon(Icons.send, color: Colors.red))
        ],
      ),
    );
  }
}
