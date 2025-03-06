import 'package:flutter/material.dart';
import 'package:joblinc/features/chat/widgets/chat_message.dart';
import 'package:joblinc/features/chat/widgets/chat_receiver.dart';
import 'package:joblinc/features/chat/widgets/new_message.dart';
import 'package:joblinc/features/chat/widgets/chat_date_now.dart';
import 'package:joblinc/features/chat/widgets/chat_more_actions.dart';
import 'package:joblinc/features/chat/widgets/star_button.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const MoreActions(); // Display the ChatAttach widget
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text('Ali Niazi'), //Name of the person
            Padding(padding: const EdgeInsets.only(bottom: 13),
              child: Row(
                children: [
                  Icon(
                    Icons.circle, 
                    size: 8, 
                    color: Colors.green
                  ),

                  const SizedBox(width: 4),

                  Text(
                    'Active now', //Last active time/Online status
                    style: TextStyle(fontSize: 12,
                    color: Colors.grey[40]),
                  ),
                ],
              ),
            )
          ]
        ),
        actions: [
          IconButton(
            onPressed: (){
              _showMoreActions(context);
            }, 
            icon: const Icon(Icons.more_horiz),
          ),
          IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.video_call),
          ),
          // IconButton(
          //   onPressed: (){},
          //   icon: const Icon(Icons.star_border),
          // ),
          StarButton(),
        ],
      ),

      body: Column(
        children: [
          ChatReceiver(
            imageUrl: "https://randomuser.me/api/portraits",
            name: "Ali Niazi",
            isVerified: true,
            description: "Studying communication and computer engineering at Cairo University",
          ),

          ChatDateNow(),

          Expanded(
            child: ChatMessage()
          ),
          NewMessage(),
          //ChatAttach(),
        ],
      )
    );
  }
}