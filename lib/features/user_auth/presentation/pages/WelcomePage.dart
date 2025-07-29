import 'package:flutter/material.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:college_finder/global/common/Get_Help.dart';
import 'About_Us.dart';

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
              Icons.group,
              size: 30,
              color: Colors.black,
            ),
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
          // Main content with button after scrollable content
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          kToolbarHeight - 80, // Subtract AppBar height and bottom spacing
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Main content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 30),
                          // Welcome text
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Welcome",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: " to your College Prep Journey",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Feature Cards
                          _buildFeatureCard(0, "This app will help you keep track of everything you need to get ready for college.", Colors.yellow[200]!, Colors.pink[100]!),
                          _buildFeatureCard(1, "Each grade has its own tasks, but it's a good idea to explore them all to see the big picture and understand what's ahead.", Colors.yellow[200]!, Colors.pink[100]!),
                          _buildFeatureCard(2, "Everything here is carefully chosen, so you can trust it to guide you in the right direction. You've got this!", Colors.yellow[200]!, Colors.pink[100]!),
                        ],
                      ),
                    ),
                    // Spacer to push button to bottom
                    Spacer(),
                    // Button area - appears after content but maintains consistent bottom spacing
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 110.0, vertical: 40.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/home", arguments: true);
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
                              textScaler: TextScaler.noScaling,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Help button
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetHelpPage()),
                );
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent,
                child: Image.asset(
                  'assets/help.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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