import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo), // Set background color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color
              ),
              onPressed: () {
                // Action for Acronyms button
              },
              child: Text('Acronyms'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo), // Set background color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color
              ),
              onPressed: () {
                // Action for Mentorship button
              },
              child: Text('Mentorship'),
            ),
          ],
        ),
      );
    },
  );
}