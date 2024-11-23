import 'dart:io' show File, Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import Syncfusion PDF Viewer
import '../../../../global/common/document_list.dart';
import 'Tasks.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:college_finder/global/common/Get_Help.dart';

class DocumentUploadPage extends StatefulWidget {
  final Task task;
  final String? userUUID = FirebaseAuth.instance.currentUser?.uid;

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
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // File name
      String fileName = result.files.single.name;

      try {
        if (kIsWeb) {
          // For Web
          Uint8List? fileBytes = result.files.single.bytes;
          if (fileBytes != null) {
            await firebase_storage.FirebaseStorage.instance
                .ref('resumes/${widget.userUUID}/$fileName')
                .putData(fileBytes);
          }
        } else {
          // For Mobile platforms (iOS/Android)
          File file = File(result.files.single.path!);
          await firebase_storage.FirebaseStorage.instance
              .ref('resumes/${widget.userUUID}/$fileName')
              .putFile(file);
        }

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
            child: Container(color: Color(0xFFF9F9F9)),
          ),
          Column(
            children: [
              CommonHeader.Header(dynamicText: "Document Upload", grade: widget.task.grade),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Center(
                          child: Column(
                            children: [
                              // Drop Zone
                              Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade400, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.upload_file, size: 40, color: Colors.indigo),
                                    SizedBox(height: 8),
                                    Text(
                                      'Drag & Drop your resume here or click to upload',
                                      style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: uploadResume,
                                      child: Text('Upload Document'),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 30),

                              // Uploaded Documents
                              if (uploadedResumeUrls.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Uploaded Documents',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: uploadedResumeUrls.length,
                                      itemBuilder: (context, index) {
                                        String resumeUrl = uploadedResumeUrls[index];
                                        String resumeName = Uri.decodeFull(
                                            resumeUrl.split('%2F').last.split('?').first.replaceAll('%20', ' '));
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Card(
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: ListTile(
                                              contentPadding: EdgeInsets.all(8.0),
                                              title: Text(
                                                resumeName,
                                                style: TextStyle(
                                                    color: Colors.indigo, fontWeight: FontWeight.w500),
                                              ),
                                              trailing: Icon(Icons.open_in_new, color: Colors.indigo),
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PdfViewerPage(pdfUrl: resumeUrl),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (widget.task.documents.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(
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
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,  // Positioned to the bottom right
            child: GestureDetector(
              onTap: () {
                // Navigate to GetHelpPage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetHelpPage()),
                );
              },
              child: CircleAvatar(
                radius: 25, // Smaller size for the button
                backgroundColor: Colors.blueAccent,
                child: Text(
                  "?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,  // Adjusted font size for the "?" text
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
      body: SfPdfViewer.network(pdfUrl), // Display PDF using Syncfusion PDF Viewer
    );
  }
}
