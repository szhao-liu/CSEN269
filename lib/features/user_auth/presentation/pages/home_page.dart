import 'package:flutter/material.dart';
import 'Quiz9Page.dart'; // Import the Quiz1Page

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CollegeGuide"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle sign-out here
              // Example: FirebaseAuth.instance.signOut();
              // Redirect to login page
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Quiz1Page when clicking on "Take Quiz"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Quiz9Page()),
                );
              },
              child: Text("Go to HomePage"),
            ),
            SizedBox(height: 20),
            // Add other buttons as needed
          ],
        ),
      ),
    );
  }
}
