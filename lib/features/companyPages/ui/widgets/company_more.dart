import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompanyMoreButton extends StatelessWidget {
  const CompanyMoreButton({super.key});

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const MoreActions(); // Add const
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showMoreActions(context);
      },
      child: const Icon(Icons.more_horiz_outlined, color: Colors.black), // Add const
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.black, // Border color
            width: 0.5, // Border width
          ),
        ), 
        padding: const EdgeInsets.all(5), 
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        fixedSize: Size(10.w, 10.h), 

      ),
    );
  }
}


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
                icon: Icon(Icons.ios_share),
                onPressed: () {},
              ),
              Text(
                'Share via',
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
                icon: Icon(Icons.send),
                onPressed: () {},
              ),
              Text(
                'Send in a message',
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
                icon: Icon(Icons.flag_rounded),
                onPressed: () {},
              ),
              Text(
                'Report abuse',
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
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
              Text(
                'Create a LinkedIn Page',
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