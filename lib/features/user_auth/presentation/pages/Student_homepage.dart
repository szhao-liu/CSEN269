import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart' as CommonHeader;
import 'Student_benefits.dart';
import 'Student_choose_grade.dart';
import 'Student_testimonials.dart';
import 'package:myapp/global/common/showHelpDialog.dart';
import 'CommonFooter.dart';

void main() {
  runApp(Student_homepage());
}

class Student_homepage extends StatelessWidget {
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
            padding: EdgeInsets.zero, // Set padding to zero to eliminate default padding
            children: [
              CommonHeader.Header(dynamicText: "HomePage"),
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
                        fontFamily: 'MadimiOne', // Replace with the desired font family
                      ),
                    ),
                  ],
                ),
              ),
              OptionCard(
                title: 'Why College?',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Student_testimonials()),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: OptionCard(
                  title: 'My Benefits',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Student_benefits()),
                    );
                  },
                ),
              ),
              OptionCard(
                title: 'Explore career',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentChooseGrade()),
                  );
                },
              ),
              SizedBox(height: 16), // Add some space between options and buttons
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
                  SizedBox(width: 16), // Add some space between buttons
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
  final VoidCallback? onTap;

  OptionCard({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.deepPurple[50] ?? Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Adjust the color and opacity as needed
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Offset to create a little shadow below the container
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
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

