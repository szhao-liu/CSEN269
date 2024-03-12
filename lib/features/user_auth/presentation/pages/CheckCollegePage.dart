import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart';
import 'CollegeSearch.dart';

class CheckCollegePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Header(dynamicText: "College Search"),
                SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Suggest College button press
                        // You can navigate to a specific page or perform any desired action
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[200],
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Suggest College",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Search on my own button press
                        // Navigate to CollegeSearch.dart page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CollegeSearch()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo[200],
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Search on my own",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle Get Help button press
                          // You can show a dialog or perform any desired action
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[200],
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Get Help",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Your additional content goes here
              ],
            ),
          ),
        ],
      ),
    );
  }
}
