import 'package:flutter/material.dart';

import 'Tasks.dart';

class VideoPage extends StatefulWidget {
  final Task task;

  const VideoPage({Key? key, required this.task}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  // Define a default video link
  final List<Video> videos = [
    Video(title: 'Default Video', thumbnailUrl: 'https://i3.ytimg.com/vi/K4Ze-Sp6aUE/maxresdefault.jpg', videoUrl: 'https://www.youtube.com/watch?v=K4Ze-Sp6aUE&pp=ygUbaGVhbHRoIGFuZCB3ZWxsbmVzcyBwb2RjYXN0'),
    // Add other videos here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Videos')),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(videos[index].thumbnailUrl),
            title: Text(videos[index].title),
            onTap: () {
              // Navigate to video link
            },
          );
        },
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
