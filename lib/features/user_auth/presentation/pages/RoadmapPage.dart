import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart';
import 'package:myapp/global/common/Header.dart' as CommonHeader;
import 'CheckCollegePage.dart';
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 16),
              CommonHeader.Header(dynamicText: "Roadmap"), // Use CommonHeader.Header widget
              SizedBox(height: 20),
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
        SizedBox(height: 60), // Add space here
        ListTileWithDropdown(title: 'Professional Development', options: [
          'Meet with a counsellor',
          'Explore extra-curricular activities',
          'Explore internship opportunities',
        ]),
        ListTileWithDropdown(title: 'Developing skills', options: [
          'Technical skills',
          'Writing skills',

        ]),
        ListTileWithDropdown(title: 'Study tips', options: [
          'Establishing study habits',
          'Set study goals'
        ]),
        ListTileWithDropdown(title: 'Academic planning', options: [
          'Set academic goals',
          'Post Secondary Education Capacity Development'
        ]),
        ListTileWithDropdown(title: 'Financial aid', options: [
          'Aid 1',
          'Aid 2',
          'Aid 3',
        ]),
        ListTileWithDropdown(title: 'Well being', options: [
          'Healthy life style',
          'Stress Management',
          'Healthy well being',
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
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
              ),
              child: Text(
                'Check Colleges',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 20), // Add some space between buttons
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
                      fontSize: 20,
                      fontFamily: 'MadimiOne'
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
                      fontFamily: 'MadimiOne',
                      fontSize: 18,
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
