import 'package:flutter/material.dart';

class ImageMediaWidget extends StatelessWidget {
  final String url;

  const ImageMediaWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingIndicator(loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildLoadingIndicator(ImageChunkEvent loadingProgress) {
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 40, color: Colors.red),
          SizedBox(height: 8),
          Text("Failed to load image", style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
