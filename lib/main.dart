import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/user_auth/presentation/pages/MustKnowPage.dart';

import 'features/app/splash_screen/splash_screen.dart';
import 'features/user_auth/presentation/pages/home_page.dart';
import 'features/user_auth/presentation/pages/login_page.dart';
import 'features/user_auth/presentation/pages/sign_up_page.dart'; // Import Firebase Auth
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/user_auth/presentation/pages/Quiz1Page.dart';
import 'features/user_auth/presentation/pages/MustKnowPage.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBwlXZjDodx4lvfLnak8Hp7aMJb25I9z_o",
        appId: "1:36597009887:android:e97af98db4a0597b53486a",
        messagingSenderId: "36597009887",
        projectId: "college-finder-54f2c",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
    '/quiz1': (context) => Quiz1Page(),
        '/mustknow': (context) => MustKnowPage(),
      },
    );
  }
}