import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;

class GetHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(
        dynamicText: "Get Help",
        grade: null,
        showBackArrow: true,
        actions: [],  // Remove the About Us button by keeping actions as empty list
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFF9F9F9)),  // Background color
          ),
          Align(
            alignment: Alignment.topCenter,  // Align the content in the top center
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 110), // Increased gap below the header
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,  // Set container width (85% of screen width)
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          _buildFeatureCard(
                            context,
                            "Click on each tab to see a detailed explanation of the term.",
                            Colors.orange[200]!,
                            Colors.purple[100]!,
                          ),
                          const SizedBox(height: 40),
                          _buildFeatureCard(
                            context,
                            "Then, swipe to complete a simple task related to it.",
                            Colors.orange[200]!,
                            Colors.purple[100]!,
                          ),
                          const SizedBox(height: 40),
                          _buildFeatureCard(
                            context,
                            "Once you finish, check the box to track your progress.",
                            Colors.orange[200]!,
                            Colors.purple[100]!,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String description, Color color1, Color color2) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Cereal',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
    );
  }
}
