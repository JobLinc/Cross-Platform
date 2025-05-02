import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';

// class DocumentViewerScreen extends StatelessWidget {
//   final String url;
//   final String type; // 'image', 'pdf', 'other'

//   const DocumentViewerScreen({required this.url, required this.type, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (type == 'image') {
//       return Scaffold(
//         appBar: AppBar(),
//         body: PhotoView(
//           imageProvider: NetworkImage(url),
//         ),
//       );
//     } else if (type == 'pdf') {
//       return Scaffold(
//         appBar: AppBar(),
//         body: PDFView(
//           filePath: url,
//         ),
//       );
//     } else {
//       // For other docs, try to open with external app
//       OpenFile.open(url);
//       return Scaffold(
//         appBar: AppBar(),
//         body: Center(child: Text('Opening document...')),
//       );
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DocumentViewerScreen extends StatefulWidget {
  final String url;
  final String type; // 'image', 'pdf', 'other'

  const DocumentViewerScreen({required this.url, required this.type, Key? key})
      : super(key: key);

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  String? localPath;
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'pdf') {
      _downloadPdf();
    } else if (widget.type != 'image' &&
        widget.type != 'doc' &&
        widget.type != 'docs') {
      // For other types, open in Chrome immediately
      _openInChrome(widget.url);
    }
  }

  Future<void> _downloadPdf() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/${widget.url.split('/').last}');
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localPath = file.path;
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load PDF';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading PDF';
        loading = false;
      });
    }
  }

  Future<void> _openInChrome(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _downloadAndOpenDoc(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/${url.split('/').last}');
        await file.writeAsBytes(response.bodyBytes);
        await OpenFile.open(file.path); // This will open with an external app
      }
    } catch (e) {
      print('Error downloading or opening document: $e');
      setState(() {
        error = 'Error downloading or opening document';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'image') {
      return Scaffold(
        appBar: AppBar(),
        body: PhotoView(
          imageProvider: NetworkImage(widget.url),
        ),
      );
    } else if (widget.type == 'pdf') {
      return Scaffold(
        appBar: AppBar(),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!))
                : localPath != null
                    ? PDFView(filePath: localPath!)
                    : Center(child: Text('No PDF to display')),
      );
    } else if (widget.type == 'doc' || widget.type == 'docs') {
      // Download and open doc/docx files with external app
      _downloadAndOpenDoc(widget.url);
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Opening document...')),
      );
    } else {
      // For other docs, try to open with external app
      OpenFile.open(widget.url);
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Opening document...')),
      );
    }
  }
}
