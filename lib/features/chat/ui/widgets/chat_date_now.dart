import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDateNow extends StatelessWidget {
  const ChatDateNow({super.key});

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM d').format(now).toUpperCase();
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1, // Height of the horizontal line
            color: Colors.grey, // Color of the line
          ),
        ),  
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              formattedDate, // Display the formatted date
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}