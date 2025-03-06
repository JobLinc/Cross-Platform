import 'package:flutter/material.dart';

class ChatReceiver extends StatelessWidget {
  final String _imageUrl;
  final String _name;
  final bool _isVerified;
  final String _description;

  //const ChatReceiver({super.key});

   ChatReceiver({
    required String imageUrl,
    required String name,
    required bool isVerified,
    required String description,
  })  : _imageUrl = imageUrl,
        _name = name,
        _isVerified = isVerified,
        _description = description;

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_imageUrl!),
                  radius: 40,
                ),
              ),
              Row(
                children: [
                  Text(
                    _name + ' ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18)
                    ),
                  if (_isVerified!) Icon(Icons.verified_user_outlined),
                ],
              ),
          Text(_description!),
        ],
      ),
    );
  }
}