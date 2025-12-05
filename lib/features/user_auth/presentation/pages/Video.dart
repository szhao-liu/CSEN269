import 'dart:convert';

import 'package:college_finder/global/common/ChatBotButton.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../../global/common/document_list.dart';
import 'Tasks.dart';

class VideoPage extends StatefulWidget {
  final Task task;

  const VideoPage({Key? key, required this.task}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {

  Future<List<Map<String, String>>> parseVideos(List<String> links) async {
    // Initialize an empty list to store the video data
    List<Map<String, String>> videoData = [];

    // Loop through each link to fetch video details
    for (String link in links) {
      var jsonData = await getDetail(link); // Fetch the video details

      if (jsonData != null) {
        videoData.add({
          'title': jsonData['title'],
          // Fallback if title is null
          'thumbnailUrl': jsonData['thumbnail_url'],
          // Use the fetched thumbnail URL or default
          'videoUrl': link,
        });
      }
    }

    return videoData; // Return the list of video data
  }

  Future<dynamic> getDetail(String userUrl) async {
    String embedUrl = "https://www.youtube.com/oembed?url=$userUrl&format=json";

    try {
      var res = await http.get(Uri.parse(embedUrl)); // HTTP GET request

      print("get youtube detail status code: ${res.statusCode}");

      if (res.statusCode == 200) {
        return json.decode(
            res.body); // Decode JSON if the request is successful
      } else {
        return null; // Return null if the status code is not 200
      }
    } on FormatException catch (e) {
      print('Invalid JSON: ${e.toString()}');
      return null; // Return null in case of a JSON format error
    }
  }


  /// Launches a URL and handles potential errors
  Future<void> _launchVideo(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Displays an error message if the URL cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch video: $url')),
      );
    }
  }

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
            child: Container(color: const Color(0xFFF9F9F9)),
          ),
          FutureBuilder<List<Map<String, String>>>(
            future: parseVideos(widget.task.links),
            // Call parseVideos to fetch video data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading videos: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No videos available'));
              }

              final videoData = snapshot.data!; // Get the fetched data

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      'Task: ${widget.task.title}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                        fontFamily: 'Cereal',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: videoData.length,
                      itemBuilder: (context, index) {
                        final video = videoData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (video['thumbnailUrl'] != '')
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12.0)),
                                    child: Image.network(
                                      video['thumbnailUrl']!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                      loadingBuilder: (context, child,
                                          loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      },
                                      errorBuilder: (context, error,
                                          stackTrace) {
                                        return const SizedBox(
                                          height: 200,
                                          child: Center(
                                              child: Text('Thumbnail Error')),
                                        );
                                      },
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    video['title']!,
                                    style: const TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _launchVideo(video['videoUrl']!),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Watch Video',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
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
                              builder: (context) =>
                                  DocumentListPage(
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
              );
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ChatBotButton(
              radius: 25,
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}