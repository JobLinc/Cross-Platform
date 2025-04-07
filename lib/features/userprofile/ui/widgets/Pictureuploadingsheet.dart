import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/userProfile/data/repo/user_profile_repository.dart';
import 'package:joblinc/features/userprofile/data/service/file_pick_service.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class ChooseCameraGallery extends StatelessWidget {
  const ChooseCameraGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Tile 1"),
              onTap: () async {
                File? image = await pickImage("camera");
                // Do something when Tile 1 is tapped
                print("Tile 1 tapped");
                context.read<ProfileCubit>().uploadProfilePicture(image!);
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Tile 2"),
              onTap: () async {
                File? image = await pickImage("gallery");
                // Do something when Tile 2 is tapped
                print("Tile 2 tapped");
                context.read<ProfileCubit>().uploadProfilePicture(image!);
                // Response response = await getIt<UserProfileRepository>()
                //     .uploadProfilePicture(image!);
                // print(response.statusCode);
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
          ],
        ),
      ),
    );
  }
}
