import 'package:flutter/material.dart';
import 'Quiz9Page.dart';
import 'Quiz10Page.dart';
import 'Quiz11Page.dart';
import 'Quiz12Page.dart';



void main() {
  runApp(Student_choose_grade());
}

class Student_choose_grade extends StatelessWidget {
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
      appBar: AppBar(
        title: Text("Choose Your Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Choose an option:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          OptionButton(
            '9th Grade',
            onTap: () {
              // Implement the action when the option is selected
              Navigator.push(context, MaterialPageRoute(builder: (context) => Quiz9Page()));
            },
          ),
          SizedBox(height: 10),
          OptionButton("Option 3"),
          SizedBox(height: 10),
          OptionButton("Option 4"),
          SizedBox(height: 10),
          OptionButton("Option 5"),
          SizedBox(height: 8),
          Image.asset(
            'assets/college_student.png', // Replace 'your_image.png' with your image asset path
            width: 175,
            height: 175,

          ),
        ],

      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String optionText;
  final VoidCallback? onTap;

  OptionButton(this.optionText, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(optionText),
        ),
      ),
    );
  }
}
