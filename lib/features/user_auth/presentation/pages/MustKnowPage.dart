import 'package:flutter/material.dart';
import 'MustKnow2Page.dart';

class MustKnowPage extends StatelessWidget {
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
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
                    Column(
                      children: [
                        Text(
                          "Hey Student!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Icon(
                          Icons.face,
                          size: 40,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "College Prep Essential",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Must Knows Before You Go!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10), // Add some space between header and blocks
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: _buildCollegeBlock(
                    index == 2
                        ? "Trade or Vocational College"
                        : (index == 0
                        ? "Community College"
                        : "Four Year College"),
                    index == 2
                        ? Colors.green[300]
                        : (index == 0
                        ? Colors.lightBlue[100]
                        : Colors.yellow[200]),
                    Icons.info,
                    context,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollegeBlock(String text, Color? color, IconData icon,
      BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to MustKnow2Page when the block is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MustKnow2Page()),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 90,
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}