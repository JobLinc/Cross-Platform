import 'package:flutter/material.dart';

class ChatAttach extends StatelessWidget {
  const ChatAttach({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(  
      children: [
        Padding(
          padding: EdgeInsets.only(top:10, bottom: 2, left:5),
          child: Row( 
            children:[
              IconButton(
                icon: Icon(Icons.document_scanner_rounded),
                onPressed: () {},
              ),
              Text(
                'Send a document',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top:2, bottom: 2, left:5),
          child: Row( 
            children:[
              IconButton(
                icon: Icon(Icons.camera_alt_rounded),
                onPressed: () {},
              ),
              Text(
                'Take a photo or video',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top:2, bottom: 2, left:5),
          child: Row( 
            children:[
              IconButton(
                icon: Icon(Icons.image_rounded),
                onPressed: () {},
              ),
              Text(
                'Select a media from library',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top:2, bottom: 2, left:5),
          child: Row( 
            children:[
              IconButton(
                icon: Icon(Icons.gif),
                onPressed: () {},
              ),
              Text(
                'Select a GIF',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top:2, bottom: 10, left:5),
          child: Row( 
            children:[
              IconButton(
                icon: Icon(Icons.alternate_email),
                onPressed: () {},
              ),
              Text(
                'Mention a person',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ),
        ),
        
      ],
    );
  }
}


// import 'package:joblinc/features/chat/ui/widgets/chat_attach.dart';
// import 'package:joblinc/features/chat/ui/widgets/chat_message.dart';
// import 'package:joblinc/features/chat/ui/widgets/chat_receiver.dart';
// import 'package:joblinc/features/chat/ui/widgets/new_message.dart';
// import 'package:joblinc/features/chat/ui/widgets/chat_date_now.dart';
// import 'package:joblinc/features/chat/ui/widgets/chat_more_actions.dart';
// import 'package:joblinc/features/chat/ui/widgets/star_button.dart';

// class ChatScreen extends StatelessWidget {
//   ChatScreen({super.key});

//   void _showMoreActions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return const MoreActions();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children:[
//             Text('Ali Niazi'), //Name of the person
//             Padding(padding: const EdgeInsets.only(bottom: 13),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.circle,
//                     size: 8,
//                     color: Colors.green
//                   ),

//                   const SizedBox(width: 4),

//                   Text(
//                     'Active now', //Last active time/Online status
//                     style: TextStyle(fontSize: 12,
//                     color: Colors.grey[40]),
//                   ),
//                 ],
//               ),
//             )
//           ]
//         ),
//         actions: [
//           IconButton(
//             onPressed: (){
//               _showMoreActions(context);
//             },
//             icon: const Icon(Icons.more_horiz),
//           ),
//           IconButton(
//             onPressed: (){},
//             icon: const Icon(Icons.video_call),
//           ),
//           // IconButton(
//           //   onPressed: (){},
//           //   icon: const Icon(Icons.star_border),
//           // ),
//           StarButton(),
//         ],
//       ),

//       body: Column(
//         children: [
//           ChatReceiver(
//             imageUrl: "https://randomuser.me/api/portraits",
//             name: "Ali Niazi",
//             isVerified: true,
//             description: "Studying communication and computer engineering at Cairo University",
//           ),

//           ChatDateNow(),

//           Expanded(
//             child: ChatMessage()
//           ),
//           NewMessage(),
//           //ChatAttach(),
//         ],
//       )
//     );
//   }
// }

  // void _initializeSocket() {
  //   socket = IO.io("http://localhost", <String, dynamic>{
  //     "transports": ["websocket"],
  //     "autoConnect": false,
  //   });

  //   socket.connect();
  //   socket.onConnect((_) {
  //     print("Connected to chat socket");
  //     socket.emit("openChat", [widget.chat.chatId, mockMainUser.id]);
  //   });

  //   // Handle received messages
  //   socket.on("receiveMessage", (data) {
  //     setState(() {
  //       messages.add(Message.fromJson(data));
  //     });
  //   });


  //   socket.on("userStatus", (data) {
  //     setState(() => status = data["status"]);
  //   });
  // }


                    // Expanded(
                  //   child: TextField(
                  //     controller: messageController,
                  //     decoration:
                  //         const InputDecoration(hintText: "Write a message..."),
                  //     onChanged: (text) {
                  //       if (text.isNotEmpty)
                  //         startTyping();
                  //       else
                  //         stopTyping();
                  //     },
                  //     onEditingComplete: stopTyping,
                  //   ),
                  // ),


                    // Widget buildChatResciever(){
  //   return
  // }

  // Widget buildMessageList(List<Message> messages) {
  //   return Expanded(
  //     child: ListView.builder(
  //       //reverse: true,
  //       itemCount: messages.length,
  //       itemBuilder: (context, index) {
  //         bool isMe = messages[index].senderId == mockMainUser.id;
  //         Message message = messages[index];
  //         return Align(
  //           alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  //           child: Container(
  //               margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: isMe ? Colors.blue : Colors.grey[300],
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               //if(message.content)
  //               child: buildMessageContent(message)),
  //         );
  //       },
  //     ),
  //   );
  // }

// import 'package:joblinc/features/premium/data/models/user_model.dart';
// import 'package:open_file/open_file.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:video_player/video_player.dart';