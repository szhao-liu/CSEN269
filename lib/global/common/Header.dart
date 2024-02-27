import 'package:flutter/material.dart';
import '../../features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';

class Header extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _auth.getUsername(), // Assume you have a method getUsername() in your FirebaseAuthService to fetch the username
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while fetching username
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String username = snapshot.data ?? "User"; // If username is null, default to "User"
            return Container(
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
                        onPressed: context != null ? () {
                          Navigator.pop(context);
                        } : null, // Set onPressed to null if context is null
                      ),
                      Column(
                        children: [
                          Text(
                            "Hey $username!",
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
            );
          }
        }
      },
    );
  }
}
