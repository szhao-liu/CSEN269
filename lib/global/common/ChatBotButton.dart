import 'package:flutter/material.dart';
import 'package:college_finder/global/common/ChatBotPage.dart';

/// A reusable chatbot button widget that can replace help buttons
class ChatBotButton extends StatelessWidget {
  final double radius;
  final Color backgroundColor;
  final bool showIcon;
  
  const ChatBotButton({
    Key? key,
    this.radius = 25,
    this.backgroundColor = Colors.blueAccent,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatBotPage()),
        );
      },
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
          size: radius * 0.8,
        ),
      ),
    );
  }
}

/// Floating chatbot button positioned at bottom right
class FloatingChatBotButton extends StatelessWidget {
  final double bottom;
  final double right;
  final double radius;
  final Color backgroundColor;
  
  const FloatingChatBotButton({
    Key? key,
    this.bottom = 20,
    this.right = 20,
    this.radius = 25,
    this.backgroundColor = Colors.blueAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: ChatBotButton(
        radius: radius,
        backgroundColor: backgroundColor,
      ),
    );
  }
}


