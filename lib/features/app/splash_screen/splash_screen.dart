import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;

  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => widget.child!), (
          route) => false);
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
      body: Center(
        child: Text("Welcome to College Finder! Here you'll find the college of your dreams!!",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),),
      ),
    );
  }
}