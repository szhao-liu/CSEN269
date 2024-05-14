import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import webview_flutter
import 'Tasks.dart'; // Import the Task class from your custom package

class DocumentUploadPage extends StatefulWidget {
  final Task task;

  const DocumentUploadPage({Key? key, required this.task}) : super(key: key);

  @override
  _DocumentUploadPageState createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  List<String> documentUrls = [];

  @override
  void initState() {
    super.initState();
    listDocuments();
  }

  Future<void> listDocuments() async {
    try {
      // Get a reference to the base directory in Firebase Storage
      var baseDirectoryRef = firebase_storage.FirebaseStorage.instanceFor(
          bucket: "gs://college-finder-54f2c.appspot.com"
      ).ref().child("templates");

      // List all items (documents and subdirectories) in the base directory
      var listResult = await baseDirectoryRef.listAll();

      // Iterate through the items in the list result
      listResult.items.forEach((itemRef) {
        // Get the download URL of each document and add it to the documentUrls list
        itemRef.getDownloadURL().then((downloadUrl) {
          setState(() {
            documentUrls.add(downloadUrl);
          });
        });
      });
    } catch (e) {
      // Handle errors
      print('Error listing documents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Document Display')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Task Name: ${widget.task.title}'),
              subtitle: Text('Task Description: ${widget.task.description}'),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: documentUrls.length,
              itemBuilder: (context, index) {
                String documentName = Uri.decodeFull(documentUrls[index].split('%2F').last.split('?').first.replaceAll('%20', ' '));
                return ListTile(
                  title: Text(documentName),
                  onTap: () {
                    _openDocument(context, documentUrls[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDocument(BuildContext context, String downloadUrl) async {
    // Open the selected document using the download URL inside a WebView
    if (Platform.isIOS || Platform.isAndroid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentWebView(downloadUrl: downloadUrl),
        ),
      );
    } else {
      // Provide an alternative solution for macOS
      // For example, you can launch the URL in the default browser
      await launchURL(downloadUrl);
    }
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class DocumentWebView extends StatelessWidget {
  final String downloadUrl;

  const DocumentWebView({Key? key, required this.downloadUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Document Viewer')),
      body: WebView(
        initialUrl: downloadUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
