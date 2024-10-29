import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;

import 'grade.dart';

class ChatWindow extends StatefulWidget {
  final String? userUUID;
  final Grade? grade;
  const ChatWindow({Key? key, required this.userUUID, this.grade}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  late CollectionReference chatCollection;

  @override
  void initState() {
    super.initState();
    chatCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userUUID)
        .collection('chats');

    _loadMessages();
  }

  void _loadMessages() async {
    QuerySnapshot snapshot = await chatCollection.orderBy('timestamp').get();
    List<Message> loadedMessages = snapshot.docs.map((doc) {
      return Message(
        text: doc['text'],
        isUser: doc['isUser'],
      );
    }).toList();

    setState(() {
      _messages = loadedMessages;
    });
    _scrollToBottom(); // Scroll to the latest message when loaded
  }

  Future<void> _sendMessage() async {
    String userMessage = _messageController.text;
    if (userMessage.trim().isEmpty) return;

    _messageController.clear();

    await chatCollection.add({
      'text': userMessage,
      'isUser': true,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _messages.add(Message(text: userMessage, isUser: true));
    });

    _scrollToBottom(); // Scroll to the latest message

    String aiResponse = await sendQueryToGeminiAPI(userMessage);
    await chatCollection.add({
      'text': aiResponse,
      'isUser': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _messages.add(Message(text: aiResponse, isUser: false));
    });

    _scrollToBottom(); // Scroll to the latest AI response
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(dynamicText: "Chat with Team", grade: widget.grade),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type your message'),
                    onSubmitted: (value) => _sendMessage(), // Enter to send
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    bool isUser = message.isUser;
    Alignment alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    Color bubbleColor = isUser ? Colors.blueAccent : Colors.grey.shade300;
    TextStyle textStyle = TextStyle(
      color: isUser ? Colors.white : Colors.black,
      fontSize: 16,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      alignment: alignment,
      child: Container(
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isUser ? Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          message.text,
          style: textStyle,
        ),
      ),
    );
  }
}

Future<String> sendQueryToGeminiAPI(String query) async {
  String apiKey = 'AIzaSyCsa9_aQLJy08PzBnrgy42yVM7vmhXr5ok';
  Uri url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey');

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Map<String, dynamic> body = {
    'contents': [
      {
        'parts': [
          {'text': query}
        ]
      }
    ]
  };

  http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    try {
      String aiResponse = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      return aiResponse;
    } catch (e) {
      print('Error parsing response: $e');
      throw Exception('Unexpected response format');
    }
  } else {
    print('Error ${response.statusCode}: ${response.body}');
    throw Exception('Failed to fetch data: ${response.statusCode}');
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}
