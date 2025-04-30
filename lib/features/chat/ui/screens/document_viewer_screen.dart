import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';

class DocumentViewerScreen extends StatelessWidget {
  final String url;
  final String type; // 'image', 'pdf', 'other'

  const DocumentViewerScreen({required this.url, required this.type, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == 'image') {
      return Scaffold(
        appBar: AppBar(),
        body: PhotoView(
          imageProvider: NetworkImage(url),
        ),
      );
    } else if (type == 'pdf') {
      return Scaffold(
        appBar: AppBar(),
        body: PDFView(
          filePath: url,
        ),
      );
    } else {
      // For other docs, try to open with external app
      OpenFile.open(url);
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Opening document...')),
      );
    }
  }
}