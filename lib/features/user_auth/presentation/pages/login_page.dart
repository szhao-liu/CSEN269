import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_finder/global/common/grade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import '../widgets/form_container_widget.dart';
import '../../../../global/common/toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:college_finder/features/user_auth/presentation/pages/Tasks.dart';
import '../../firebase_auth_implementation/firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bb.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                Text(
                  "Welcome!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cereal',
                  ),
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cereal',
                          ),
                        ),
                        SizedBox(height: 30),
                        FormContainerWidget(
                          controller: _emailController,
                          hintText: "Email",
                          isPasswordField: false,
                        ),
                        SizedBox(height: 10),
                        FormContainerWidget(
                          controller: _passwordController,
                          hintText: "Password",
                          isPasswordField: true,
                          onFieldSubmitted: (_) => _signIn(), // Login on Enter
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: _signIn,
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue[200] ?? Colors.transparent, // Blue color with 200 shade
                                  Colors.greenAccent[100] ?? Colors.transparent, // GreenAccent with 100 shade
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _isSigning
                                  ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cereal',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: _signInWithGoogle,
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/google.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cereal',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Cereal',
                              ),
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ),
                                      (route) => false,
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cereal',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showToast(message: "Email and password cannot be empty");
      setState(() {
        _isSigning = false;
      });
      return;
    }

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");

      // Check if the user's grade is present in the Firebase DB
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null && snapshot.data()!['grade'] != "") {
        // If the user's grade is present, navigate directly to the corresponding grade
        Grade userGrade = getGradeFromString(snapshot.data()!['grade']);
        navigateToTasks(context, userGrade, Colors.cyan);
      } else {
        // If the user's grade is not present, navigate to the home page
        Navigator.pushNamed(context, "/welcomePage");
      }
    } else {
      showToast(message: "Some error occurred");
    }
  }

  void navigateToTasks(BuildContext context, Grade grade, Color color) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TasksPage(grade: grade, isNeedTour: false ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          // Check if the user already exists in Firestore
          DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (!snapshot.exists) {
            // Create a new user document if it doesn't exist
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
              'email': user.email,
              'name': user.displayName,
              'grade': "", // Default grade as empty if not provided
            });
          }

          Navigator.pushNamed(context, "/welcomePage");
        }
      }
    } catch (e) {
      showToast(message: "An error occurred: $e");
    }
  }
}
