import 'package:flutter/material.dart';

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
                          "Hey Sonam!",
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
                    SizedBox(width: 30), // Adjust spacing if needed
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
          SizedBox(height: 40),
          _buildCollegeBlock(
            "Community College",
            Colors.lightBlue[100],
            Icons.info,
          ),
          SizedBox(height: 40),
          _buildCollegeBlock(
            "Four Year College",
            Colors.yellow[200],
            Icons.info,
          ),
          SizedBox(height: 40),
          _buildCollegeBlock(
            "Trade or Vocational\nCollege",
            Colors.green[300],
            Icons.info,
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCollegeBlock(String text, Color? color, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(24),
      width: double.infinity,
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
          SizedBox(height: 8),
          Icon(
            icon,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
