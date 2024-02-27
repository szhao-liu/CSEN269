import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart';
import 'MustKnowPage.dart';

class Quiz12Page extends StatefulWidget {
  @override
  _Quiz12PageState createState() => _Quiz12PageState();
}

class _Quiz12PageState extends State<Quiz12Page> {
  List<int?> selectedOptions = List.filled(3, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         Header(),
          Expanded(
            child: ListView(
              children: [
                _buildQuestion(
                  "Are you a first-generation college student? First-generation students are the first person in their family to attend college.",
                  ['Yes', 'No'],
                  0,
                ),
                _buildQuestion(
                  "I know how to search for information about college.",
                  ['Yes', 'No'],
                  1,
                ),
                _buildQuestion(
                  "How comfortable do you feel asking your academic advisor questions?",
                  [
                    'Not comfortable at all',
                    'Somewhat comfortable',
                    'Comfortable with assistance/guidance',
                    'Comfortable',
                  ],
                  2,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          if (selectedOptions.every((option) => option != null))
            ElevatedButton(
              onPressed: () {
                // Navigate to MustKnowPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MustKnowPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestion(String question, List<String> options, int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Text(
              question,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        ...options.asMap().entries.map(
              (entry) => RadioListTile<int>(
            title: Text(
              entry.value,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            value: entry.key,
            groupValue: selectedOptions[index],
            onChanged: (value) {
              setState(() {
                selectedOptions[index] = value;
              });
            },
            activeColor: Colors.indigo,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
