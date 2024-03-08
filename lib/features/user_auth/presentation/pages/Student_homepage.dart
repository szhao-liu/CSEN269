import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart' as CommonHeader;
import 'Student_benefits.dart';
import 'Student_choose_grade.dart';
import 'Student_testimonials.dart';
import 'package:myapp/global/common/showHelpDialog.dart';

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonHeader.Header(),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Student_testimonials()),
                  );
                },
              ),
              SizedBox(height: 20),
              OptionCard(
                title: 'My Benefits',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Student_benefits()),
                  );
                },
              ),
              SizedBox(height: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 3,
          color: Colors.deepPurple[50] ?? Colors.transparent,
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
