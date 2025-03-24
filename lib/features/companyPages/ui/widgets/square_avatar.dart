import 'package:flutter/material.dart';

class SquareAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;

  const SquareAvatar({
    required this.imageUrl,
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.rectangle // Square shape
          ),
      child: Image(
        errorBuilder: (context, error, stackTrace) => Container(),
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover, // Ensure the image covers the entire square
      ),
    );
  }
}
