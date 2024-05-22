// lib/global/common/Header.dart

import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String dynamicText;
  final bool showBackArrow;

  const Header({Key? key, required this.dynamicText, this.showBackArrow = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackArrow
          ? IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
          : null,
      title: Text(dynamicText, style: TextStyle(fontFamily: 'MadimiOne')),
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
