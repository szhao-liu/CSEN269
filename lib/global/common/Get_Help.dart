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
              size: 30,
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
                  // Modern Header Section
                  _buildHeaderSection(),
                  const SizedBox(height: 32),
                  // How to Use Section
                  _buildSectionTitle("How to Use", Icons.help_outline),
                  const SizedBox(height: 16),
                  const FeatureCardsWidget(),
                  const SizedBox(height: 32),
                  // Account Settings Section
                  _buildSectionTitle("Account Settings", Icons.settings_outlined),
                  const SizedBox(height: 16),
                  LogoutButton(),
                  const SizedBox(height: 12),
                  DeleteAccountButton(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.indigo.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.help_center,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to Get Help!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'Cereal',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find answers and manage your account',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
              fontFamily: 'Cereal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.indigo.shade700,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
            fontFamily: 'Cereal',
          ),
        ),
      ],
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
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
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              "Logout",
              style: TextStyle(
                fontFamily: 'Cereal',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade800.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          bool confirmDelete = await _showConfirmationDialog(context);
          if (confirmDelete) {
            _deleteAccount(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade900,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              "Delete Account",
              style: TextStyle(
                fontFamily: 'Cereal',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 28),
              const SizedBox(width: 12),
              const Text(
                "Confirm Deletion",
                style: TextStyle(
                  fontFamily: 'Cereal',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
            style: TextStyle(
              fontFamily: 'Cereal',
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: 'Cereal',
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Delete",
                style: TextStyle(
                  fontFamily: 'Cereal',
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (Route<dynamic> route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account deleted successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting account: ${e.toString()}")),
      );
    }
  }
}

class FeatureCardsWidget extends StatefulWidget {
  const FeatureCardsWidget({Key? key}) : super(key: key);

  @override
  State<FeatureCardsWidget> createState() => _FeatureCardsWidgetState();
}

class _FeatureCardsWidgetState extends State<FeatureCardsWidget> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildExpandableFeatureCard(
          context,
          0,
          Icons.touch_app_rounded,
          "Step 1",
          "Click on each tab to see a detailed explanation of the term.",
          [
            "Navigate through different tabs in the app to explore various terms and concepts related to college preparation.",
            "Each tab contains specific information that will help you understand important terminology used in the college application process.",
            "Take your time to read through the explanations - they are designed to make complex concepts easy to understand.",
            "You can click on multiple tabs to compare different terms and concepts side by side.",
          ],
          [Colors.blue.shade400, Colors.blue.shade600],
        ),
        const SizedBox(height: 16),
        _buildExpandableFeatureCard(
          context,
          1,
          Icons.swipe_rounded,
          "Step 2",
          "Then, swipe to complete a simple task related to it.",
          [
            "After reading the explanation, you'll find a related task or activity to complete.",
            "Swipe left or right on the task card to mark it as complete or to access task details.",
            "Tasks are designed to help you actively engage with the concepts you just learned.",
            "Completing tasks helps reinforce your understanding and prepares you for your college journey.",
            "You can revisit tasks anytime to review or update your progress.",
          ],
          [Colors.purple.shade400, Colors.purple.shade600],
        ),
        const SizedBox(height: 16),
        _buildExpandableFeatureCard(
          context,
          2,
          Icons.check_circle_outline_rounded,
          "Step 3",
          "Once you finish, check the box to track your progress.",
          [
            "After completing a task, check the box next to it to mark it as done.",
            "Your progress is automatically saved, so you can track what you've accomplished.",
            "The checked boxes help you visualize your journey and see how much you've completed.",
            "You can view your overall progress at any time to stay motivated and organized.",
            "Uncheck a box if you need to revisit a task or update your work.",
            "Celebrate your progress - each checked box represents a step closer to your college goals!",
          ],
          [Colors.green.shade400, Colors.green.shade600],
        ),
      ],
    );
  }

  Widget _buildExpandableFeatureCard(
    BuildContext context,
    int index,
    IconData icon,
    String step,
    String description,
    List<String> details,
    List<Color> gradientColors,
  ) {
    final isExpanded = _expandedIndex == index;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _expandedIndex = isExpanded ? null : index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon Container
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step,
                            style: TextStyle(
                              fontFamily: 'Cereal',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: const TextStyle(
                              fontFamily: 'Cereal',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow Icon with rotation animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      transform: Matrix4.identity()..rotateZ(isExpanded ? 3.14159 : 0.0),
                      child: Icon(
                        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: Colors.white.withOpacity(0.8),
                        size: 28,
                      ),
                    ),
                  ],
                ),
                // Expanded Details
                if (isExpanded) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detailed Information:",
                          style: TextStyle(
                            fontFamily: 'Cereal',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.95),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...details.asMap().entries.map((entry) {
                          int index = entry.key;
                          String detail = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(bottom: index == details.length - 1 ? 0 : 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6, right: 10),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    detail,
                                    style: TextStyle(
                                      fontFamily: 'Cereal',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
