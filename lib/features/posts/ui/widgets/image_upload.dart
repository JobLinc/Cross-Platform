import 'package:flutter/material.dart';

class ImageUploadWidget extends StatelessWidget {
  final Widget imageWidget;
  final Future<void> uploadFuture;
  final Color loadingOverlayColor;
  final Widget? loadingIndicator;
  final VoidCallback? onUploadComplete;
  final Function(Object)? onUploadError;

  const ImageUploadWidget({
    super.key,
    required this.imageWidget,
    required this.uploadFuture,
    this.loadingOverlayColor = const Color(0x66000000),
    this.loadingIndicator,
    this.onUploadComplete,
    this.onUploadError,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: uploadFuture,
      builder: (context, snapshot) {
        // Handle upload completion
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Call error callback if provided
            if (onUploadError != null) {
              onUploadError!(snapshot.error!);
            }
          } else {
            // Call completion callback if provided
            if (onUploadComplete != null) {
              onUploadComplete!();
            }
          }
        }

        // Show the image with a loading overlay if upload is in progress
        return Stack(
          alignment: Alignment.center,
          children: [
            // The image to display
            imageWidget,

            // Show overlay with loading indicator when uploading
            if (snapshot.connectionState == ConnectionState.waiting)
              Container(
                color: loadingOverlayColor,
                child: Center(
                  child: loadingIndicator ??
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                ),
              ),

            // Show success checkmark when upload completes
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasError)
              Container(
                color: const Color(0x6600FF00), // Light green overlay
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),

            // Show error icon if upload failed
            if (snapshot.hasError)
              Container(
                color: const Color(0x66FF0000),
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
