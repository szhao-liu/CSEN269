import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../features/user_auth/presentation/pages/login_page.dart';
import '../../../features/user_auth/presentation/pages/WelcomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // 1) Wait for the first auth state (completes immediately if known)
    final User? user = await FirebaseAuth.instance.authStateChanges().first;

    // 2) Enforce a minimum splash duration (match your old 3s)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // 3) Navigate based on auth state
    if (user != null) {
      // User already signed in
      Navigator.pushReplacementNamed(context, '/welcomePage');
    } else {
      // Not signed in
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show your splash art while bootstrapping
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cc.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}


// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snap){
//         if (snap.connectionState == ConnectionState.waiting) {
//           return _SplashArt();
//         }

//         final user = snap.data;
//         if (user != null) {
//           return  WelcomePage();
//         } else {
//           return const LoginPage();
//         }
//       },
//     );
//   }
// }

// class _SplashArt extends StatelessWidget {
//   const _SplashArt();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(image: AssetImage('assets/cc.png'),
//           fit: BoxFit.cover,
//           ),
//         ),
//         child: const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }



// class SplashScreen extends StatefulWidget {
//   final Widget? child;

//   const SplashScreen({Key? key, this.child}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     Future.delayed(
//       const Duration(seconds: 3),
//           () {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => widget.child!),
//               (route) => false,
//         );
//       },
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/cc.png'), // Replace with your image asset
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: CircularProgressIndicator(), // or any other widget you want to show
//         ),
//       ),
//     );
//   }
// }
