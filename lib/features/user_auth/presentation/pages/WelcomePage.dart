import 'package:flutter/material.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:college_finder/global/common/Get_Help.dart'; // Import the GetHelpPage
import 'About_Us.dart'; // Import your About_Us.dart file

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(
        dynamicText: "",
        grade: null,
        showBackArrow: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.group,  // Group of people icon
              size: 30,  // Increase the size of the icon
              color: Colors.black,
            ), // Replaced the "i" icon with a team icon
            tooltip: 'About Us',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
        ],
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Welcome",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Blue color for 'Welcome'
                          ),
                        ),
                        TextSpan(
                          text: " to your College Prep Journey",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Black color for the rest of the text
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Updated Feature Cards with the new text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      _buildFeatureCard(0, "This app will help you keep track of everything you need to get ready for college.", Colors.yellow[200]!, Colors.pink[100]!),
                      _buildFeatureCard(1, "Each grade has its own tasks, but it’s a good idea to explore them all to see the big picture and understand what’s ahead.", Colors.yellow[200]!, Colors.pink[100]!),
                      _buildFeatureCard(2, "Everything here is carefully chosen, so you can trust it to guide you in the right direction. You’ve got this!", Colors.yellow[200]!, Colors.pink[100]!),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 110.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blueAccent,
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
          // Positioned "?" button at the bottom right corner with smaller size
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
                child: Image.asset(
                  'assets/help.png',  // Replace with the correct path to your image
                  fit: BoxFit.cover,  // Ensures the image fits within the circle
                ),
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
      ),
    );
  }
}