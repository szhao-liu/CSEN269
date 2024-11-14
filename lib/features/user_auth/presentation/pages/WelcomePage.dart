import 'package:flutter/material.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:college_finder/global/common/chat_window.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(
        dynamicText: "Welcome to College Finder",
        grade: null,
        showBackArrow: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(color: Color(0xFFF9F9F9)),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      _buildFeatureCard(0, "The checklist will help you keep track of everything you need to get ready for college.", Colors.yellow[200]!, Colors.pink[100]!),
                      _buildFeatureCard(1, "Click on each tab to see a detailed explanation of the term. Then, swipe to complete a simple task related to it.", Colors.yellow[200]!, Colors.pink[100]!),
                      _buildFeatureCard(0, "We’ve also added a chat box feature, allowing you to interact with an AI to explore additional options related to your process.", Colors.yellow[200]!, Colors.pink[100]!),
                      _buildFeatureCard(1, "Everything here is carefully chosen, so you can trust it to guide you in the right direction. You’ve got this!", Colors.yellow[200]!, Colors.pink[100]!),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blueAccent, // Use blueAccent color
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatWindow(userUUID: null),
                    ),
                  );
                },
                child: Icon(Icons.chat_rounded, color: Colors.white),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to create feature cards with alternating alignment and gradient colors
  Widget _buildFeatureCard(int index, String description, Color color1, Color color2) {
    return Align(
      alignment: index % 2 == 0 ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            colors: [color1, color2], // Two colors for the gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Cereal', // You can customize this with your desired font
                fontSize: 18, // You can adjust this as per your design
                fontWeight: FontWeight.normal,
                color: Colors.black, // Text color should be white for better readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}
