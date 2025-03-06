import 'package:flutter/material.dart';

class MoreActions extends StatelessWidget {
  const MoreActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(  
      children: [
        Padding(
          padding: EdgeInsets.only(top:10, bottom: 2, left:5),
          child: Row( 
            children:[
              IconButton(
                icon: Icon(Icons.drive_file_move_sharp),
                onPressed: () {},
              ),
              Text(
                'Move to Other',
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
                icon: Icon(Icons.email_outlined),
                onPressed: () {},
              ),
              Text(
                'Mark as unread',
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
                icon: Icon(Icons.star_border),
                onPressed: () {},
              ),
              Text(
                'Star',
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
                icon: Icon(Icons.volume_off_outlined),
                onPressed: () {},
              ),
              Text(
                'Mute',
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
                icon: Icon(Icons.archive_outlined),
                onPressed: () {},
              ),
              Text(
                'Archive',
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
                icon: Icon(Icons.flag),
                onPressed: () {},
              ),
              Text(
                'Report / Block',
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
                icon: Icon(Icons.delete),
                onPressed: () {},
              ),
              Text(
                'Delete conversation',
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
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
              Text(
                'Manage settings',
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