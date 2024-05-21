import 'package:flutter/material.dart';
import 'Tasks.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgg.jpg'),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 55.0),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                'Resources to improve your mental health',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
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
                            padding: const EdgeInsets.all(0.0),
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
                              // Navigate to video link
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
          ],
        ),
      ),
    );
  }
}

class Video {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;

  Video({required this.title, required this.thumbnailUrl, required this.videoUrl});
}
