import 'package:flutter/material.dart';
import 'package:college_finder/features/user_auth/presentation/pages/Tasks.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../global/common/chat_window.dart';
import '../../../../global/common/grade.dart';
import '../../../../global/common/toast.dart';
import 'package:college_finder/global/common/Get_Help.dart';

class StudentChooseGrade extends StatelessWidget {
  final bool showShowcase;

  const StudentChooseGrade({Key? key, this.showShowcase=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("showShowcase: $showShowcase");
    return ShowCaseWidget(
      builder: (context) { return MyHomePage(showShowcase: showShowcase);},
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool showShowcase;

  const MyHomePage({required this.showShowcase});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _chatButtonKey = GlobalKey();
  final Map<Grade, GlobalKey> _gradeKeys = {
    for (var grade in Grade.values) grade: GlobalKey(),
  };

  String? userUUID;
  bool shouldShowShowcase = false;

  @override
  void initState() {
    super.initState();
    userUUID = FirebaseAuth.instance.currentUser?.uid;
    
    if (widget.showShowcase) {
      _checkIfShouldShowShowcase();
    }
  }

  // Check if user has seen the showcase before
  Future<void> _checkIfShouldShowShowcase() async {
    if (userUUID == null) return;
    
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userUUID);
      final userSnapshot = await userRef.get();
      
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final hasSeenShowcase = userData['hasSeenGradeShowcase'] ?? false;
        
        if (!hasSeenShowcase) {
          setState(() {
            shouldShowShowcase = true;
          });
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShowCaseWidget.of(context).startShowCase([
              ..._gradeKeys.values,
              _chatButtonKey,
            ]);
          });
          
          // Mark that user has seen the showcase
          await userRef.update({'hasSeenGradeShowcase': true});
        }
      } else {
        // First time user, show showcase
        setState(() {
          shouldShowShowcase = true;
        });
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowCaseWidget.of(context).startShowCase([
            ..._gradeKeys.values,
            _chatButtonKey,
          ]);
        });
      }
    } catch (e) {
      print("Error checking showcase status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(
          dynamicText: "Choose Grade", grade: null, showBackArrow: false),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(color: Color(0xFFF9F9F9)),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                for (Grade grade in Grade.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30.0),
                    child: Showcase(
                      key: _gradeKeys[grade]!,
                      description: "Choose ${grade.grade} if you are in grade ${grade.grade}.",
                      child: OptionCard(
                        title: grade.grade,
                        color: grade.fixedColor,
                        onTap: () {
                          addGrade(userUUID, grade.grade).then((_) {
                            navigateToTasks(context, grade);
                          });
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetHelpPage()),
                );
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent,
                child: Image.asset(
                  'assets/help.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addGrade(String? userUUID, String grade) async {
    if (userUUID == null) {
      print("User didnt login");
      return;
    }
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userUUID);
      final userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        await userRef.set({
          'grade': grade,
          'hasSeenGradeShowcase': true, // Set this when creating user
        });
      } else {
        await userRef.update({
          'grade': grade,
          'hasSeenGradeShowcase': true, // Update this field
        });
      }
      
      showToast(message: "User is successfully signed in");
    } catch (e) {
      showToast(message: "Failed to add grade: $e");
      throw e;
    }
  }

  void navigateToTasks(BuildContext context, Grade grade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TasksPage(grade: grade),
      ),
      //(Route<dynamic> route) => false,
    );
  }
}

class OptionCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color color;

  OptionCard({required this.title, this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepPurple[400],
                fontFamily: 'Cereal',
              ),
            ),
          ),
        ),
      ),
    );
  }
}