import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myapp/global/common/Header.dart' as CommonHeader;
import 'package:myapp/global/common/showHelpDialog.dart';
import 'CommonFooter.dart';

void main() {
  runApp(Student_benefits());
}

class Student_benefits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudentBenefits(),
    );
  }
}

class StudentBenefits extends StatelessWidget {
  final List<String> funFacts = [
    "Fun Fact 1: Over one's lifetime, a person with a bachelor's degree stands to earn 1 million more than someone with a high school diploma",
    "Fun Fact 2: Studies show that college graduates report higher levels of personal satisfaction and well-being compared to non-graduates.",
    "Fun Fact 3: Colleges offer libraries, research facilities, career centers, and other resources that can enhance your learning and development.",
    // Add more fun facts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgg.jpg',
            fit: BoxFit.cover,
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              CommonHeader.Header(dynamicText: "Student Benefits"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'College Guide',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MadimiOne',
                      ),
                    ),
                  ],
                ),
              ),
              OptionCard(
                title: 'Scholarships',
                tagline: 'Tagline for Scholarships',
              ),
              OptionCard(
                title: 'Work-Study',
                tagline: 'Tagline for Work-Study',
              ),
              OptionCard(
                title: 'Emergency Funding',
                tagline: 'Tagline for Emergency Funding',
              ),
              OptionCard(
                title: 'Housing benefits',
                tagline: 'Tagline for Housing benefits',
              ),
              SizedBox(height: 8),

              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      showHelpDialog(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                    ),
                    child: Text(
                      'Get Help',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String title;
  final String tagline;

  OptionCard({required this.title, required this.tagline});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
      child: GestureDetector(
        onTap: () {
          print("Selected: $title");
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.deepPurple[50] ?? Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple[400],
                    fontFamily: 'MadimiOne',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  tagline,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple[400],
                    fontFamily: 'MadimiOne',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



