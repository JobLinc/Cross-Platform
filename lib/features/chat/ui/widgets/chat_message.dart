import 'package:flutter/material.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_bubble.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:8.0, right:8.0),
          child: ListView(
            children: [
              SizedBox(height: 10),
               ChatBubble.first(
                userImage: 'https://randomuser.me/api/portraits',
                username: 'Ahmed Hesham',
                message: 'Hello, how are you?',
                isMe: true,
                time: DateTime.now(),
              ),
              ChatBubble.next(
                message: 'Wishing you a very happy birthday!',
                isMe: true,
                time: DateTime.now(),
              ),
              ChatBubble.first(
                userImage: 'https://randomuser.me/api/portraits',
                username:'Ali Niazi',
                message: '7obbi 😘😘❤️❤️',
                isMe: false,
                time: DateTime.now()
              ),
            ],
          ),
        ),
      ],
      
    )
    ;
  }
}