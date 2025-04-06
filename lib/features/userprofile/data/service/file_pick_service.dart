import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(String choice) async {
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  final XFile? pickedFile = await picker.pickImage(
      source: choice == "gallery" ? ImageSource.gallery : ImageSource.camera);

  if (pickedFile != null) {
    imageFile = File(pickedFile.path);
    print("Image selected");
    print(imageFile.path);
    // Use _imageFile however you want (e.g. setState)
  } else {
    print("No image selected.");
  }
  return imageFile;
}
