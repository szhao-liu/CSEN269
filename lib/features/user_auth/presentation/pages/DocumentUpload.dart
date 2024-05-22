import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import webview_flutter
import 'Tasks.dart'; // Import the Task class from your custom package
import 'package:myapp/global/common/Header.dart' as CommonHeader; // Import the common Header file

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
      body: Stack(
        children: [
          CommonHeader.Header(dynamicText: "Document Upload"), //
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/backgg.jpg', // Make sure the image is located in the assets folder and listed in pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Custom header
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.all(16.0),

                  child: Text(
                    'Resume Resources',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: documentUrls.length,
                  itemBuilder: (context, index) {
                    String documentName = Uri.decodeFull(documentUrls[index].split('%2F').last.split('?').first.replaceAll('%20', ' '));
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.description, color: Colors.indigo),
                          title: Text(
                            documentName,
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward, color: Colors.indigo),
                          onTap: () {
                            _openDocument(context, documentUrls[index]);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
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
      appBar: AppBar(
        title: Text("Document Viewer"),
        backgroundColor: Colors.indigo,
      ),
      body: WebView(
        initialUrl: downloadUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
