import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ChatAttach extends StatelessWidget {
  final Function(String, String)? onFileSelected;

  const ChatAttach({super.key, this.onFileSelected});

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && onFileSelected != null) {
      onFileSelected!(result.files.first.path!, 'document');
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null && onFileSelected != null) {
      onFileSelected!(photo.path, 'image');
    }
  }

  Future<void> _pickMedia() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result != null && onFileSelected != null) {
      final String type =
          result.files.first.path!.toLowerCase().endsWith('.mp4')
              ? 'video'
              : 'image';
      onFileSelected!(result.files.first.path!, type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 2, left: 5),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.document_scanner_rounded),
              onPressed: _pickDocument,
            ),
            Text(
              'Send a document',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.camera_alt_rounded),
              onPressed: _takePhoto,
            ),
            Text(
              'Take a photo or video',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.image_rounded),
              onPressed: _pickMedia,
            ),
            Text(
              'Select a media from library',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.gif),
              onPressed: () {},
            ),
            Text(
              'Select a GIF',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 10, left: 5),
          child: Row(children: [
            IconButton(
              icon: Icon(Icons.alternate_email),
              onPressed: () {},
            ),
            Text(
              'Mention a person',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
