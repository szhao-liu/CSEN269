import 'package:flutter/material.dart';
import 'MustKnowPage.dart';

class Quiz11Page extends StatefulWidget {
  @override
  _Quiz11PageState createState() => _Quiz11PageState();
}

class _Quiz11PageState extends State<Quiz11Page> {
  List<int?> selectedOptions = List.filled(3, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            height: 150,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Hey Student!",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.face,
                    size: 40,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
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
