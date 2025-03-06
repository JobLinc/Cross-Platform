import 'package:flutter/material.dart';

class StarButton extends StatefulWidget {
  const StarButton({super.key});

  @override
  _StarButtonState createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  bool _isStarred = false; 

  void _toggleStar() {
    setState(() {
      _isStarred = !_isStarred; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleStar, 
      icon: Icon(
        _isStarred ? Icons.star : Icons.star_border, 
        color: _isStarred ? const Color.fromARGB(255, 174, 139, 33) : Colors.grey, 
      ),
    );
  }
}