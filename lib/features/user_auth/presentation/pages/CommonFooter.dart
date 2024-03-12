import 'package:flutter/material.dart';
import 'package:myapp/global/common/showHelpDialog.dart';

class CommonFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.indigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              // Handle navigation to home page
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          GlassmorphicButton(
            onPressed: () {
              showHelpDialog(context);
            },
            child: Text(
              'Get Help',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassmorphicButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  GlassmorphicButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: child,
      ),
    );
  }
}
