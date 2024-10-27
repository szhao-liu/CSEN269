import 'dart:io' show File, Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import webview_flutter
import '../../../../global/common/document_list.dart';
import 'Tasks.dart'; // Import the Task class from your custom package
import 'package:college_finder/global/common/Header.dart' as CommonHeader; // Import the common Header file

class DocumentUploadPage extends StatefulWidget {
  final Task task;
  final String? userUUID = FirebaseAuth.instance.currentUser?.uid; // Add the user UUID

  DocumentUploadPage({Key? key, required this.task}) : super(key: key);

  @override
  _DocumentUploadPageState createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  List<String> uploadedResumeUrls = [];

  @override
  void initState() {
    super.initState();
    fetchUploadedResumes();
  }

  Future<void> fetchUploadedResumes() async {
    try {
      final resumesRef = firebase_storage.FirebaseStorage.instance.ref('resumes/${widget.userUUID}');
      final listResult = await resumesRef.listAll();

      List<String> urls = [];
      for (var item in listResult.items) {
        String downloadUrl = await item.getDownloadURL();
        urls.add(downloadUrl);
      }

      setState(() {
        uploadedResumeUrls = urls;
      });
    } catch (e) {
      print('Error fetching resumes: $e');
    }
  }

  Future<void> uploadResume() async {
    // Use FilePicker to select a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      // Upload the file to Firebase Storage
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('resumes/${widget.userUUID}/$fileName')
            .putFile(file);
        String downloadUrl = await firebase_storage.FirebaseStorage.instance
            .ref('resumes/${widget.userUUID}/$fileName')
            .getDownloadURL();

        setState(() {
          uploadedResumeUrls.add(downloadUrl);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resume uploaded successfully')),
        );
      } catch (e) {
        print('Error uploading resume: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading resume')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgg.jpg', // Make sure the image is located in the assets folder and listed in pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                CommonHeader.Header(dynamicText: "Document Upload", grade: widget.task.grade),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: uploadResume,
                  child: Text('Upload Document'),
                ),
                SizedBox(height: 20),
                if (uploadedResumeUrls.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: uploadedResumeUrls.length,
                    itemBuilder: (context, index) {
                      String resumeUrl = uploadedResumeUrls[index];
                      String resumeName = Uri.decodeFull(resumeUrl.split('%2F').last.split('?').first.replaceAll('%20', ' '));
                      return ListTile(
                        title: Text(resumeName),
                        onTap: () => _openDocument(context, resumeUrl),
                      );
                    },
                  ),
                SizedBox(height: 30),
                if (widget.task.documents.isNotEmpty)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocumentListPage(
                              documents: widget.task.documents,
                            ),
                          ),
                        );
                      },
                      child: Text('Help Needed?'),
                    ),
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
