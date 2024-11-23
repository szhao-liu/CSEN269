import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../global/common/chat_window.dart';
import '../../../../global/common/document_list.dart';
import 'Tasks.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:college_finder/global/common/Get_Help.dart';

class VideoPage extends StatefulWidget {
  final Task task;

  const VideoPage({Key? key, required this.task}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  // Define a list of videos
  final List<Video> videos = [
    Video(
      title: 'Tips for a strong career',
      thumbnailUrl: 'https://img.youtube.com/vi/b_ZFjw-eEGo/maxresdefault.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=b_ZFjw-eEGo',
    ),
    // Add other videos here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(
        dynamicText: "Videos",
        grade: widget.task.grade,
        showBackArrow: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Color(0xFFF9F9F9)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white.withOpacity(0.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              videos[index].thumbnailUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                videos[index].title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final url = videos[index].videoUrl;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Watch Video',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                    child: const Text(
                      'Help Needed?',
                      style: TextStyle(fontFamily: 'Cereal'),
                    ),
                  ),
                ),
              SizedBox(height: 30),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ChatWindow(
      //           userUUID: FirebaseAuth.instance.currentUser?.uid,
      //           grade: widget.task.grade,
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

class Video {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;

  Video({required this.title, required this.thumbnailUrl, required this.videoUrl});
}
