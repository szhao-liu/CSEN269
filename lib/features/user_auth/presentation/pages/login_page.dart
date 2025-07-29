import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_finder/global/common/grade.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import '../widgets/form_container_widget.dart';
import '../../../../global/common/toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
      ),
      child: Scaffold(
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
                            onFieldSubmitted: (_) => _signIn(),
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
                                    Colors.blue[200] ?? Colors.transparent,
                                    Colors.greenAccent[100] ?? Colors.transparent,
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
                                    ? CircularProgressIndicator(color: Colors.white)
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
                          _socialSignInButtons(),
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
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
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
      ),
    );
  }

  Widget _socialSignInButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: _signInWithGoogle,
          child: _socialButton('assets/google.png', "Sign in with Google"),
        ),
        SizedBox(height: 10),
        if (Theme.of(context).platform == TargetPlatform.iOS) // Show only on iOS
          GestureDetector(
            onTap: signInWithApple,
            child: _socialButton(null, "Sign in with Apple", isApple: true),
          ),
      ],
    );
  }

  Widget _socialButton(String? iconPath, String text, {bool isApple = false}) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isApple ? Colors.black : Colors.white,
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
            if (iconPath != null) Image.asset(iconPath, height: 25, width: 25),
            if (isApple) Icon(Icons.apple, color: Colors.white, size: 25),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isApple ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cereal',
              ),
            ),
          ],
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
      showToast(message: "Email and password cannot be empty.");
      setState(() {
        _isSigning = false;
      });
      return;
    }

    try {
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        showToast(message: "Login successful!");
        Navigator.pushReplacementNamed(context, "/welcomePage");
      }
    } on FirebaseAuthException catch (e) {
      showToast(message: e.message ?? "Login failed.");
    } finally {
      setState(() {
        _isSigning = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        showToast(message: "Google sign-in canceled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        showToast(message: "Google sign-in successful!");
        Navigator.pushReplacementNamed(context, "/welcomePage");
      }
    } catch (e) {
      showToast(message: "Google sign-in failed: $e");
    }
  }

  /// Generates a cryptographically secure random nonce
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the SHA-256 hash of [input] in hex notation
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Signs in with Apple and Firebase
  Future<void> signInWithApple() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Generate a nonce
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce, // Hashed nonce for Apple
      );

      // Create an OAuthCredential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce, // Unhashed nonce for Firebase
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
      await auth.signInWithCredential(oauthCredential);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Handle missing email (Apple only provides email on first login)
        String? email = appleCredential.email ?? firebaseUser.email;

        // If email is still null, retrieve from Firestore (if stored previously)
        if (email == null) {
          final doc =
          await firestore.collection("users").doc(firebaseUser.uid).get();
          if (doc.exists) {
            email = doc.data()?["email"];
          }
        }

        // Save email & name on first sign-in
        if (appleCredential.email != null) {
          await firestore.collection("users").doc(firebaseUser.uid).set({
            "email": appleCredential.email,
            "fullName":
            "${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}".trim(),
            "createdAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }

      print("Apple Sign-In Success: ${firebaseUser?.email}");
      Navigator.pushReplacementNamed(context, "/welcomePage");
    } catch (e) {
      print("Apple Sign-In Error: $e");
      return null;
    }
  }
}
