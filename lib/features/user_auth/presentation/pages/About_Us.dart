import 'package:flutter/material.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:college_finder/global/common/Get_Help.dart'; // Import the GetHelpPage

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(
        dynamicText: "About Us",
        grade: null,
        showBackArrow: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Color(0xFFF9F9F9), // Set the background color same as WelcomePage
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // First Section
                    SizedBox(height: 16),
                    Image.asset(
                      'assets/logo1.png', // Replace with the actual path to your asset
                      height: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Located in the heart of Silicon Valley, Santa Clara University blends high-tech innovation with a social consciousness grounded in the Jesuit educational tradition.We are committed to leaving the world a better place. We pursue new technology, encourage creativity, engage with our communities, and share an entrepreneurial mindset. Our goal is to help shape the next generation of leaders and global thinkers.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 32),

                    // Second Section
                    SizedBox(height: 16),
                    Image.asset(
                      'assets/logo2.png', // Replace with the actual path to your asset
                      height: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Thriving Neighbors is a community Engaged Learning Program connecting Santa Clara University with the predominantly Latino Greater Washington community in San Jose. It fosters collaboration among SCU members, local agencies, and Latino communities to advance equity and inclusion.The program focuses on enhancing K-12 education in STEM and leadership, co-creating programs for capacity building, and providing SCU students with hands-on learning opportunities.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 32),

                    // Third Section
                    SizedBox(height: 16),
                    Image.asset(
                      'assets/logo3.png', // Replace with the actual path to your asset
                      height: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "The Frugal Innovation Hub, at its core, fulfills Santa Clara University's comprehensive and holistic Jesuit mission while simultaneously actualizing the School of Engineering as a humanitarian-technology leader in Silicon Valley.The program is positioned with the resources, strategic alignment, and impetus to become the nucleus of humanitarian technology development, research, and implementation on a global stage.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          // Positioned "?" button at the bottom right corner
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
}
