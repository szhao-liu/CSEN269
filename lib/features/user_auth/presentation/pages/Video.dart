import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../global/common/chat_window.dart';
import '../../../../global/common/document_list.dart';
import 'Tasks.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;

class VideoPage extends StatefulWidget {
  final Task task;

  const VideoPage({Key? key, required this.task}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  // Function to parse video details from task links
  List<Map<String, String>> parseVideos(List<String> links) {
    return links.map((link) {
      final videoId = Uri.parse(link).queryParameters['v'] ?? '';
      return {
        'title': 'Video', // Default title (can enhance this by fetching actual titles via API)
        'thumbnailUrl': 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg',
        'videoUrl': link,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> videoData = parseVideos(widget.task.links);

    return Scaffold(
      appBar: CommonHeader.Header(
        dynamicText: "Videos",
        grade: widget.task.grade,
        showBackArrow: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFF9F9F9)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: videoData.length,
                  itemBuilder: (context, index) {
                    final video = videoData[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white.withOpacity(0.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              video['thumbnailUrl'] ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                video['title'] ?? 'Video Title',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final url = video['videoUrl']!;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
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
                      'References',
                      style: TextStyle(fontFamily: 'Cereal'),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatWindow(
                userUUID: FirebaseAuth.instance.currentUser?.uid,
                grade: widget.task.grade,
              ),
            ),
          );
        },
        child: const Icon(Icons.chat_rounded),
        backgroundColor: const Color(0xFF0560FB),
      ),
    );
  }
}
