import 'package:flutter/material.dart';

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
          OptionButton("Scholarships"),
          SizedBox(height: 10),
          OptionButton("Option 2"),
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

  OptionButton(this.optionText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0), // Add padding on left and right
      child: Container(
        width: double.infinity, // Makes the button take the full width
        child: ElevatedButton(
          onPressed: () {
            // Implement the action when the option is selected
            print("Selected: $optionText");
          },
          child: Text(optionText),
        ),
      ),
    );
  }
}