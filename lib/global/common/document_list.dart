import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:http/http.dart' as http;
import 'pdf_viewer_page.dart';

class DocumentListPage extends StatefulWidget {
  final List<String> documents;

  const DocumentListPage({Key? key, required this.documents}) : super(key: key);

  @override
  _DocumentListPageState createState() => _DocumentListPageState();
}

class _DocumentListPageState extends State<DocumentListPage> {
  String _extractFileName(String url) {
    return Uri.parse(url).pathSegments.last.split('?').first;
  }

  Future<void> _openDocument(BuildContext context, String url) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(pdfUrl: url),
      ),
    );
  }

  Future<void> _downloadDocument(BuildContext context, String url) async {
    final fileName = _extractFileName(url);
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$fileName');

    if (!await file.exists()) {
      try {
        final response = await http.get(Uri.parse(url));
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$fileName downloaded to ${directory.path}')),
        );
      } catch (e) {
        print('Error downloading file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading file: $fileName')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$fileName already exists in ${directory.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Color(0xFFF9F9F9)),
          ),
          Column(
            children: [
              CommonHeader.Header(dynamicText: "References", grade: null),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.documents.length,
                  itemBuilder: (context, index) {
                    final fileUrl = widget.documents[index];
                    final fileName = _extractFileName(fileUrl);

                    return ListTile(
                      title: Text(fileName),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.open_in_new),
                            onPressed: () => _openDocument(context, fileUrl),
                          ),
                          IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () => _downloadDocument(context, fileUrl),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
