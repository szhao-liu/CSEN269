import 'dart:io' show File;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import Syncfusion PDF Viewer
import 'package:college_finder/global/common/Header.dart' as CommonHeader;

//import 'chat_window.dart';

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
        final downloadTask = FirebaseStorage.instance.refFromURL(url).writeToFile(file);
        final snapshot = await downloadTask;
        if (snapshot.state == TaskState.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$fileName downloaded to ${directory.path}')),
          );
        }
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ChatWindow(
      //           userUUID: FirebaseAuth.instance.currentUser?.uid
      //         ),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.chat_rounded),
      //   backgroundColor: Color(0xFF0560FB),
      // ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document Viewer"),
        backgroundColor: Colors.indigo,
      ),
      body: SfPdfViewer.network(pdfUrl), // Use Syncfusion PDF Viewer for viewing PDFs
    );
  }
}
