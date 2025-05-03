import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
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
