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