import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart';
import 'CheckCollegePage.dart';
//import 'CheckCollegePage.dart';
import 'package:myapp/global/common/showHelpDialog.dart';

void main() {
  runApp(RoadmapPage());
}

class RoadmapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
         // CommonHeader.Header(),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'Roadmap',
                style: TextStyle(
                  fontSize: 36, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo, // Changed color to white for better contrast
                  fontFamily: 'Montserrat', // Example custom font family
                ),
              ),
              SizedBox(height: 16),
              OptionsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTileWithDropdown(title: 'Professional Development', options: [
          'Option 1',
          'Option 2',
          'Option 3',
        ]),
        ListTileWithDropdown(title: 'Test Preparations', options: [
          'Option A',
          'Option B',
          'Option C',
        ]),
        ListTileWithDropdown(title: 'Study tips', options: [
          'Tip 1',
          'Tip 2',
          'Tip 3',
        ]),
        ListTileWithDropdown(title: 'Academic planning', options: [
          'Plan A',
          'Plan B',
          'Plan C',
        ]),
        ListTileWithDropdown(title: 'Financial aid', options: [
          'Aid 1',
          'Aid 2',
          'Aid 3',
        ]),
        ListTileWithDropdown(title: 'Well being', options: [
          'Wellness 1',
          'Wellness 2',
          'Wellness 3',
        ]),
        SizedBox(height: 16), // Add some space between options and buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                //Add your action here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckCollegePage()),
                );

              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.indigo),
              ),
              child: Text(
                'Check Colleges',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 16), // Add some space between buttons
            TextButton(
              onPressed: () {
                showHelpDialog(context);

              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.indigo),
              ),
              child: Text(
                'Get Help',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ListTileWithDropdown extends StatefulWidget {
  final String title;
  final List<String> options;

  ListTileWithDropdown({required this.title, required this.options});

  @override
  _ListTileWithDropdownState createState() => _ListTileWithDropdownState();
}

class _ListTileWithDropdownState extends State<ListTileWithDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: _isExpanded
                        ? Icon(Icons.arrow_drop_up)
                        : Icon(Icons.arrow_drop_down),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            height: 1,
          ), // Add a light gray line below the option
          if (_isExpanded)
            Column(
              children: widget.options
                  .map((option) => ListTile(
                title: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}