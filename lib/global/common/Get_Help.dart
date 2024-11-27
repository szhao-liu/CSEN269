import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;

import '../../features/user_auth/presentation/pages/About_Us.dart';

class GetHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(
        dynamicText: "Get Help",
        grade: null,
        showBackArrow: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.group, // Group of people icon
              size: 30, // Increased the size of the icon
              color: Colors.black,
            ),
            tooltip: 'About Us',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFF9F9F9)),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Welcome to Get Help!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FeatureCardsWidget(),
                  const SizedBox(height: 20),
                  LogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (Route<dynamic> route) => false, // Clear the navigation stack
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error logging out: ${e.toString()}")),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        "Logout",
        style: TextStyle(
          fontFamily: 'Cereal',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FeatureCardsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildFeatureCard(
            context,
            "Click on each tab to see a detailed explanation of the term.",
            Colors.orange[200]!,
            Colors.purple[100]!,
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
            context,
            "Then, swipe to complete a simple task related to it.",
            Colors.orange[200]!,
            Colors.purple[100]!,
          ),
          const SizedBox(height: 20),
          _buildFeatureCard(
            context,
            "Once you finish, check the box to track your progress.",
            Colors.orange[200]!,
            Colors.purple[100]!,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String description, Color color1, Color color2) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Cereal',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
    );
  }
}
