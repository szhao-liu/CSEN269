import 'package:college_finder/features/user_auth/presentation/pages/WelcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'features/app/splash_screen/splash_screen.dart';
import 'features/user_auth/presentation/pages/CommonFooter.dart';
import 'features/user_auth/presentation/pages/Student_choose_grade.dart';
import 'features/user_auth/presentation/pages/Tasks.dart';
import 'features/user_auth/presentation/pages/login_page.dart';
import 'features/user_auth/presentation/pages/sign_up_page.dart';
import 'firebase_options.dart';
import 'global/common/grade.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      name: "Track2College",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(CollegeFinder());
}

class CollegeFinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Finder',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => SplashScreen(
                child: LoginPage(),
              ),
            );
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginPage());
          case '/signUp':
            return MaterialPageRoute(builder: (context) => SignUpPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => StudentChooseGrade());
          case '/welcomePage':
            return MaterialPageRoute(builder: (context) => WelcomePage());
          case '/tasks':
          // Extract grade from the route arguments
            final String gradeArg = settings.arguments as String;
            final Grade grade = getGradeFromString(gradeArg); // Convert string to Grade
            return MaterialPageRoute(
              builder: (context) => TasksPage(grade: grade),
            );
          case '/choosegrade':
            return MaterialPageRoute(builder: (context) => StudentChooseGrade());
          case '/commonfooter':
            return MaterialPageRoute(builder: (context) => CommonFooter());
        // Add cases for other routes as needed
          default:
            return null;
        }
      },
    );
  }
}
