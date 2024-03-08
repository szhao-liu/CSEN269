import 'package:flutter/material.dart';
import 'Student_choose_grade.dart';
import 'Quiz.dart'; // Import the common Quiz file
import 'package:myapp/global/common/Header.dart' as CommonHeader;

void main() {
  runApp(StudentChooseGrade());
}

class StudentChooseGrade extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgg.jpg', // Replace with your background image asset path
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonHeader.Header(), // Use the Header from the common library
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose Your Grade',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),// Added CommonHeader.Header()
              SizedBox(height: 20),
              OptionCard(
                title: '9th Grade',
                onTap: () {
                  navigateToQuiz(context, '9th Grade');
                },
              ),
              SizedBox(height: 20),
              OptionCard(
                title: '10th Grade',
                onTap: () {
                  navigateToQuiz(context, '10th Grade');
                },
              ),
              SizedBox(height: 20),
              OptionCard(
                title: '11th Grade',
                onTap: () {
                  navigateToQuiz(context, '11th Grade');
                },
              ),
              SizedBox(height: 20),
              OptionCard(
                title: '12th Grade',
                onTap: () {
                  navigateToQuiz(context, '12th Grade');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void navigateToQuiz(BuildContext context, String grade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Quiz(grade: grade),
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
      padding: const EdgeInsets.symmetric(horizontal: 70.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(title),
        ),
      ),
    );
  }
}
