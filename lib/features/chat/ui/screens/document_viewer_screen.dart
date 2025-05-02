import 'package:flutter/material.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
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
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// class DocumentViewerScreen extends StatefulWidget {
//   final String url;
//   final String type; // 'image', 'pdf', 'other'

//   const DocumentViewerScreen({required this.url, required this.type, Key? key})
//       : super(key: key);

//   @override
//   State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
// }

// class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
//   String? localPath;
//   bool loading = false;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.type == 'pdf') {
//       _downloadPdf();
//     } else if (widget.type != 'image' &&
//         widget.type != 'doc' &&
//         widget.type != 'docs') {
//       // For other types, open in Chrome immediately
//       _openInChrome(widget.url);
//     }
//   }

//   Future<void> _downloadPdf() async {
//     setState(() {
//       loading = true;
//       error = null;
//     });
//     try {
//       final response = await http.get(Uri.parse(widget.url));
//       if (response.statusCode == 200) {
//         final dir = await getTemporaryDirectory();
//         final file = File('${dir.path}/${widget.url.split('/').last}');
//         await file.writeAsBytes(response.bodyBytes);
//         setState(() {
//           localPath = file.path;
//           loading = false;
//         });
//       } else {
//         setState(() {
//           error = 'Failed to load PDF';
//           loading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         error = 'Error loading PDF';
//         loading = false;
//       });
//     }
//   }

//   Future<void> _openInChrome(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }

//   Future<void> _downloadAndOpenDoc(String url) async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final dir = await getTemporaryDirectory();
//         final file = File('${dir.path}/${url.split('/').last}');
//         await file.writeAsBytes(response.bodyBytes);
//         await OpenFile.open(file.path); // This will open with an external app
//       }
//     } catch (e) {
//       print('Error downloading or opening document: $e');
//       setState(() {
//         error = 'Error downloading or opening document';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.type == 'image') {
//       return Scaffold(
//         appBar: AppBar(),
//         body: PhotoView(
//           imageProvider: NetworkImage(widget.url),
//         ),
//       );
//     } else if (widget.type == 'pdf') {
//       return Scaffold(
//         appBar: AppBar(),
//         body: loading
//             ? Center(child: CircularProgressIndicator())
//             : error != null
//                 ? Center(child: Text(error!))
//                 : localPath != null
//                     ? PDFView(filePath: localPath!)
//                     : Center(child: Text('No PDF to display')),
//       );
//     } else if (widget.type == 'doc' || widget.type == 'docs') {
//       // Download and open doc/docx files with external app
//       _downloadAndOpenDoc(widget.url);
//       return Scaffold(
//         appBar: AppBar(),
//         body: Center(child: Text('Opening document...')),
//       );
//     } else {
//       // For other docs, try to open with external app
//       OpenFile.open(widget.url);
//       return Scaffold(
//         appBar: AppBar(),
//         body: Center(child: Text('Opening document...')),
//       );
//     }
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:photo_view/photo_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentViewerScreen extends StatefulWidget {
  final String url;

  const DocumentViewerScreen({required this.url, Key? key}) : super(key: key);

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  String? _localPath;
  double _progress = 0;
  String? _error;
  bool _loading = false;
  late final String _ext;

  @override
  void initState() {
    super.initState();
    _ext = widget.url.split('.').last.toLowerCase();
    _handleFile();
  }

  Future<void> _handleFile() async {
    if (_ext == 'pdf') {
      await _downloadWithProgress(widget.url);
    } else if (['doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'].contains(_ext)) {
      // embed via Google Docs Viewer
      setState(() => _loading = false);
    } else if (['jpg', 'jpeg', 'png', 'gif'].contains(_ext)) {
      // nothing to download
      setState(() => _loading = false);
    } else {
      // other — try open externally
      await _openExternally(widget.url);
      setState(() => _loading = false);
    }
  }

  Future<void> _downloadWithProgress(String url) async {
    setState(() {
      _loading = true;
      _error = null;
      _progress = 0;
    });

    // request storage permission if needed
    // if (await Permission.storage.request().isDenied) {
    //   setState(() {
    //     _error = 'Storage permission denied';
    //     _loading = false;
    //   });
    //   return;
    // }

    try {
      final dir = await getTemporaryDirectory();
      final filename = url.split('/').last;
      final filePath = '${dir.path}/$filename';

      // skip download if already cached
      final file = File(filePath);
      if (await file.exists()) {
        setState(() {
          _localPath = filePath;
          _loading = false;
        });
        return;
      }

      final dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() => _progress = received / total);
          }
        },
      );

      setState(() {
        _localPath = filePath;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Download failed: $e';
        _loading = false;
      });
    }
  }

  Future<void> _openExternally(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      setState(() => _error = 'Cannot open external app.');
    }
  }

  @override
  void dispose() {
    // optionally delete cached file
    if (_localPath != null) {
      File(_localPath!).delete().ignore();
    }
    super.dispose();
  }

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://flutter.dev'));

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_loading) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(value: _progress),
            SizedBox(height: 8),
            Text('${(_progress * 100).toStringAsFixed(0)}%'),
          ],
        ),
      );
    } else if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() => _error = null);
                _handleFile();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    } else if (_ext == 'pdf' && _localPath != null) {
      body = PDFView(filePath: _localPath!);
    } else if (['jpg', 'jpeg', 'png', 'gif'].contains(_ext)) {
      body = PhotoView(imageProvider: NetworkImage(widget.url));
    } else if (['doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'msword'].contains(_ext)) {
      final embedUrl =
          'https://docs.google.com/gview?embedded=true&url=${Uri.encodeFull(widget.url)}';

      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse('https://flutter.dev'));

      body = WebViewWidget(controller: controller);
      //WebView(initialUrl: embedUrl, javascriptMode: JavascriptMode.unrestricted);
    } else {
      body = Center(child: Text('Opened in external application.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('View: ${widget.url.split('/').last}'),
      ),
      body: body,
    );
  }
}
