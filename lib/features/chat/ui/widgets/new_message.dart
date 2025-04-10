import 'package:flutter/material.dart';
import 'chat_attach.dart';


class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  // void dispose() {
  //   super.dispose();
  //   _messageController.dispose();
  // }

  // _sendMessage(){
  //   final enteredMessage = _messageController.text;

  //   if (enteredMessage.isEmpty) {
  //     return;
  //   }

  //   _messageController.clear();
  // }

   void _showAttachOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const ChatAttach(); 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, right:1, bottom: 25, top:10),

      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _showAttachOptions(context);
          }, icon: Icon(Icons.attach_file),
            //color: Colors.red,
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border:Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1.0,
                  style: BorderStyle.solid
                ),
                boxShadow:[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:12.0),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    //labelText: ' Write a message...',
                    labelStyle: TextStyle(color: Colors.grey[10]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)), // Red underline when focused
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)), // Red underline when disabled
                    ),
                    hintText: 'Write a message...', // Placeholder text
                    hintStyle: TextStyle(color: Colors.grey[10]), // Placeholder text color
                    border: InputBorder.none,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  enableSuggestions: true,
                  autocorrect: true,
                  cursorColor: Colors.red,
                ),
              ),
            )
          ),

          IconButton(onPressed: (){
            //_sendMessage();
          }, icon: Icon(
            Icons.send,
            color: Colors.red
            )
          )
      ],)
    );
  }
}