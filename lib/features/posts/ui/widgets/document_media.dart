import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class DocumentMediaWidget extends StatefulWidget {
  final String url;
  final String? title;

  const DocumentMediaWidget({super.key, required this.url, this.title});

  @override
  State<DocumentMediaWidget> createState() => _DocumentMediaWidgetState();
}

class _DocumentMediaWidgetState extends State<DocumentMediaWidget> {
  bool _isLoading = true;
  String? _localPath;
  bool _isError = false;
  int? _totalPages;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.url.startsWith('http') || widget.url.startsWith('https')) {
        // Download the file
        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.pdf';

        // Here you would use http package to download the file
        // For brevity, this is a placeholder
        // final response = await http.get(Uri.parse(widget.url));
        // await File(path).writeAsBytes(response.bodyBytes);

        _localPath = path;
      } else {
        _localPath = widget.url;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      print("Error loading document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_isError || _localPath == null) {
      return _buildErrorWidget();
    }

    // For PDF documents
    if (widget.url.toLowerCase().endsWith('.pdf')) {
      return Column(
        children: [
          // PDF viewer
          Expanded(
            child: PDFView(
              filePath: _localPath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              onRender: (pages) {
                setState(() {
                  _totalPages = pages;
                });
              },
              onPageChanged: (page, total) {
                setState(() {
                  _currentPage = page!;
                });
              },
              onError: (error) {
                setState(() {
                  _isError = true;
                });
              },
            ),
          ),

          // Page indicators and controls
          Container(
            height: 50,
            color: Colors.black.withOpacity(0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _totalPages != null
                      ? 'Page $_currentPage of $_totalPages'
                      : 'Loading pages...',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // For other document types
      return _buildGenericDocumentPreview();
    }
  }

  Widget _buildGenericDocumentPreview() {
    String fileExtension = widget.url.split('.').last.toLowerCase();
    IconData iconData;
    String fileType;

    switch (fileExtension) {
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        fileType = 'Word Document';
        break;
      case 'xls':
      case 'xlsx':
        iconData = Icons.table_chart;
        fileType = 'Excel Spreadsheet';
        break;
      case 'ppt':
      case 'pptx':
        iconData = Icons.slideshow;
        fileType = 'PowerPoint Presentation';
        break;
      case 'txt':
        iconData = Icons.article;
        fileType = 'Text Document';
        break;
      default:
        iconData = Icons.insert_drive_file;
        fileType = 'Document';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, size: 80, color: Colors.blue),
        const SizedBox(height: 16),
        Text(
          widget.title ?? 'Document',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(fileType),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Implement opening the document
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Open Document'),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.red),
          SizedBox(height: 8),
          Text("Failed to load document", style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
