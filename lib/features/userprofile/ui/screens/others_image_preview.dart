import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

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

            // Footer with 2 Image Buttons
            //   Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 16.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         GestureDetector(
            //             onTap: () {
            //               final profileCubit = context.read<ProfileCubit>();

            //               showModalBottomSheet(
            //                 context: context,
            //                 builder: (bottomSheetContext) =>
            //                     ChooseCameraGallery(),
            //               );
            //             },
            //             child: Icon(Icons.abc_outlined)),
            //         GestureDetector(
            //           onTap: () {
            //             // Button 2 action
            //           },
            //           child: IconButton(
            //               onPressed: () {}, icon: Icon(Icons.abc_outlined)),
            //         ),
            //       ],
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
