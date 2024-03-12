import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import '../widgets/form_container_widget.dart';
import '../../../../global/common/toast.dart';
import '../../firebase_auth_implementation/firebase_auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/grad2.jpg', // Replace with your background image asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Container(
              width: 350, // Adjust the width of the box as needed
              height: 450, // Adjust the height of the box as needed

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Adjust the opacity and color as needed
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "REGISTER",
                    style: TextStyle(color: Colors.blue, fontSize: 35, fontWeight: FontWeight.bold,fontFamily: 'MadimiOne',),
                  ),
                  SizedBox(height: 30),
                  FormContainerWidget(
                    controller: _usernameController,
                    hintText: "Username",
                    isPasswordField: false,
                  ),
                  SizedBox(height: 10),
                  FormContainerWidget(
                    controller: _emailController,
                    hintText: "Email Address",
                    isPasswordField: false,
                  ),
                  SizedBox(height: 10),
                  FormContainerWidget(
                    controller: _passwordController,
                    hintText: "Password",
                    isPasswordField: true,
                  ),
                  SizedBox(height: 10),
                  FormContainerWidget(
                    controller: _passwordController,
                    hintText: "Confirm Password",
                    isPasswordField: true,
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      _signUp();
                    },
                    child: Container(
                      width: 400,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [Colors.blue ?? Colors.transparent, Colors.cyanAccent[100] ?? Colors.transparent
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // You can adjust the color and opacity
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Adjust the offset as needed
                          ),
                        ],
                      ),
                      child: Center(
                        child: isSigningUp
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "SIGN UP",
                          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'MadimiOne',),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: TextStyle(fontSize: 15,color: Colors.black,
                            fontFamily: 'MadimiOne',)),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                                (route) => false,
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.blue,fontFamily: 'MadimiOne',),
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
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password, username);

    setState(() {
      isSigningUp = false;
    });
    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Some error happened");
    }
  }
}
