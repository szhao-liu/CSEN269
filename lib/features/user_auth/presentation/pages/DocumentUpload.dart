import 'dart:io' show File, Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'Tasks.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import '../../../../global/common/pdf_viewer_page.dart'; // Updated PDF viewer

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
      final resumesRef = firebase_storage.FirebaseStorage.instance
          .ref('resumes/${widget.userUUID}');
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
      String fileName = result.files.single.name;

      try {
        if (kIsWeb) {
          Uint8List? fileBytes = result.files.single.bytes;
          if (fileBytes != null) {
            await firebase_storage.FirebaseStorage.instance
                .ref('resumes/${widget.userUUID}/$fileName')
                .putData(fileBytes);
          }
        } else {
          File file = File(result.files.single.path!);
          await firebase_storage.FirebaseStorage.instance
              .ref('resumes/${widget.userUUID}/$fileName')
              .putFile(file);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resume uploaded successfully')),
        );

        fetchUploadedResumes(); // Refresh list
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
          Positioned.fill(child: Container(color: Color(0xFFF9F9F9))),
          Column(
            children: [
              CommonHeader.Header(
                  dynamicText: "Document Upload", grade: widget.task.grade),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Task: ${widget.task.title}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.indigo,
                          fontFamily: 'Cereal',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Upload Section
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.shade400, width: 2),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.upload_file,
                                size: 40, color: Colors.indigo),
                            SizedBox(height: 8),
                            Text(
                              'Drag & Drop your resume here or click to upload',
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: uploadResume,
                              child: Text('Upload Document'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
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
                                  color: Colors.indigo),
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: uploadedResumeUrls.length,
                              itemBuilder: (context, index) {
                                String resumeUrl = uploadedResumeUrls[index];
                                String resumeName = Uri.decodeFull(
                                  resumeUrl
                                      .split('%2F')
                                      .last
                                      .split('?')
                                      .first
                                      .replaceAll('%20', ' '),
                                );
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(8.0),
                                      title: Text(
                                        resumeName,
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      trailing: Icon(Icons.open_in_new,
                                          color: Colors.indigo),
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PdfViewerPage(
                                                pdfUrl: resumeUrl)),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
