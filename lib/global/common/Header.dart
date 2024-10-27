import 'package:flutter/material.dart';
import 'grade.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  final String dynamicText;
  final bool showBackArrow;
  final Grade? grade;
  final ValueChanged<Grade>? onGradeChanged;

  const Header({
    Key? key,
    required this.dynamicText,
    required this.grade,
    this.onGradeChanged,
    this.showBackArrow = true,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  Grade? selectedGrade;

  @override
  void initState() {
    super.initState();
    selectedGrade = widget.grade; // Initialize with the given grade
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.showBackArrow
          ? IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
          : null,
      title: Text(
        widget.dynamicText,
        style: TextStyle(
          fontFamily: 'MadimiOne',
          color: Colors.white,
        ),
      ),
      actions: [
        if (widget.onGradeChanged != null)
          DropdownButton<Grade>(
            value: selectedGrade,
            dropdownColor: Colors.deepPurple[100],
            style: TextStyle(fontFamily: 'MadimiOne',
              color: Colors.white),
            underline: SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            items: Grade.values.map((Grade grade) {
              return DropdownMenuItem<Grade>(
                value: grade,
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                        decoration: BoxDecoration(
                          color: grade.fixedColor, // Use the fixedColor associated with the grade
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2), // Add white border with width of 2
                        ),
                    ),
                    const SizedBox(width: 8),
                    Text(grade.grade), // Display the grade name next to the color circle
                  ],
                ),
              );
            }).toList(),
            onChanged: (Grade? newGrade) {
              if (newGrade != null) {
                setState(() {
                  selectedGrade = newGrade;
                });
                widget.onGradeChanged!(newGrade);
              }
            },
          ),
      ],
      backgroundColor: selectedGrade?.fixedColor ?? Colors.deepPurple,
      centerTitle: true,
    );
  }
}
