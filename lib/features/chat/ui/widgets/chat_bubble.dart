import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isMe,
    required this.time,
    
  }) : isFirstInSequence = true;

  const ChatBubble.next({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  final bool isFirstInSequence;
  final String? userImage;
  final String? username;
  final String message;
  final bool isMe;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm a').format(time);
    final theme = Theme.of(context);

    return Stack(
      children: [
        if (userImage != null)
          Positioned(
            top: 15,
            right:null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userImage!,
              ),
              radius: 20,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                  CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence) SizedBox(height: 18),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Row(
                        children: [
                          Text(
                            username! ,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.only(bottom:7, left:8, right: 5),
                            child: Text(
                              ".",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Text(
                            formattedTime ,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 158, 158, 158)
                    
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 7,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 6,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
