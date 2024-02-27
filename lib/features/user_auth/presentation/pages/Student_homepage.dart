import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart';
import 'Student_benefits.dart';
import 'Student_choose_grade.dart';
import 'Student_testimonials.dart';




void main() {
  runApp(Student_homepage());
}

class Student_homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Header(), // Include the header widget here
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'College Guide',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        OptionCard(
          title: 'Why College?',
          onTap: () {
            // Navigate to Page for Option 1
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Student_testimonials()));
          },
        ),
        SizedBox(height: 20),
        OptionCard(
          title: 'My Benefits',
          onTap: () {
            // Navigate to Page for Option 1
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Student_benefits()));
          },
        ),
        SizedBox(height: 20),
        OptionCard(
          title: 'Explore career',
          onTap: () {
            // Navigate to Page for Option 1
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Student_choose_grade()));
          },
        ),

        GestureDetector(
          onTap: () {
            // Handle link click action here
            print('Get Help link clicked?');
          },
          child: Text(
            'Get Help',
            style: TextStyle(
              fontSize: 18,
              color: Colors.indigo,
              decoration: TextDecoration.underline,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(height: 8),
        Image.asset(
          'assets/college_student.png',
          // Replace 'your_image.png' with your image asset path
          width: 175,
          height: 175,
        ),
      ],
    );
  }
}

class OptionCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  OptionCard({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: GestureDetector(
        onTap: onTap, // Use onTap directly on GestureDetector
        child: Card(
          elevation: 3,
          color: Colors.cyan,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

