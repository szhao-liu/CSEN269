import 'package:flutter/material.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;

class GetHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(
        dynamicText: "Get Help",
        grade: null,
        showBackArrow: true,  // Added back arrow for navigation
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
                // Large Welcome text with customized colors
                SizedBox(height: 20),
                // Main content of the page here...
              ],
            ),
          ),
          // Feature Cards Widget with increased gap
          Positioned(
            top: 120, // Increase this value to add more gap between header and widget
            left: 20,
            right: 20,
            child: FeatureCardsWidget(),
          ),
        ],
      ),
    );
  }
}

class FeatureCardsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Decreased width for the outer container
    double containerWidth = MediaQuery.of(context).size.width * 0.7;

    return Container(
      width: containerWidth, // Decreased width for the outer widget
      padding: EdgeInsets.symmetric(vertical: 20.0), // Vertical padding to add space
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFeatureCard(context, 0, "Click on each tab to see a detailed explanation of the term", Colors.orange[200]!, Colors.purple[100]!),
          SizedBox(height: 20), // Increased gap between cards
          _buildFeatureCard(context, 1, "Then, swipe to complete a simple task related to it.", Colors.orange[200]!, Colors.purple[100]!),
          SizedBox(height: 20), // Increased gap between cards
          _buildFeatureCard(context, 2, "Once you finish, check the box to track your progress.", Colors.orange[200]!, Colors.purple[100]!),
        ],
      ),
    );
  }

  // Method to create feature cards with a fixed width and consistent vertical layout
  Widget _buildFeatureCard(BuildContext context, int index, String description, Color color1, Color color2) {
    // Getting the outer container width and applying it to the feature card width
    double containerWidth = MediaQuery.of(context).size.width * 0.7;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16.0),
      width: containerWidth, // Adjust the width of the feature cards
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
              fontFamily: 'Cereal',
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
