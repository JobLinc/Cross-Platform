import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final String
      imagePath; // Just the path from your model, e.g. /uploads/img.jpg

  const FullScreenImagePage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final fullUrl = "$imagePath";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Profile photo',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            // context.read<ProfileCubit>().getUserProfile();
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Expanded Image Viewer
            Expanded(
              child: Center(
                child: Image.network(
                  fullUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey.shade400,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
