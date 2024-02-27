import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart';
import 'CheckCollegePage.dart';

class RoadmapPage extends StatefulWidget {
  @override
  _RoadmapPageState createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  Map<String, String?> selectedOptions = {
    "Professional Development": null,
    "Test Preparations": null,
    "Study Tips": null,
    "Academic Planning": null,
    "Financial Aid": null,
    "Well Being": null,
  };

  bool showHelpButtons = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            SizedBox(height: 20),
            for (var topic in selectedOptions.keys)
              _buildTopicDropdown(topic),
            SizedBox(height: 20),
            _buildCheckCollegesButton(),
            SizedBox(height: 20),
            _buildGetHelpButton(),
            SizedBox(height: 20),
            Visibility(
              visible: showHelpButtons,
              child: Column(
                children: [
                  _buildHelpButton("Acronyms and Tips"),
                  SizedBox(height: 20),
                  _buildHelpButton("Mentorship"),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicDropdown(String topic) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                topic,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String?>(
                value: selectedOptions[topic],
                items: ["Option 1", "Option 2"]
                    .map((option) => DropdownMenuItem<String?>(
                  value: option,
                  child: Text(option),
                ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOptions[topic] = newValue;
                  });
                },
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 30,
                elevation: 16,
                isExpanded: false,
                underline: SizedBox(),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildCheckCollegesButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CheckCollegePage()),
        );
        // Handle check colleges button press
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.indigo,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Check Colleges",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildGetHelpButton() {
    return ElevatedButton(
      onPressed: () {
        // Toggle the visibility of "Acronyms and Tips" and "Mentorship"
        setState(() {
          showHelpButtons = !showHelpButtons;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue[200],
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Get Help",
          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.black,),
        ),
      ),
    );
  }

  Widget _buildHelpButton(String buttonText) {
    return ElevatedButton(
      onPressed: () {
        // Handle the button press based on buttonText
        // You can navigate to a specific help page or perform any desired action
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.indigo,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
