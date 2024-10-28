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
          fontFamily: 'Cereal',
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
      actions: [
        if (widget.onGradeChanged != null)
          DropdownButton<Grade>(
            value: selectedGrade,
            dropdownColor: Color(0xFFD9D9D9),
            style: TextStyle(
              fontFamily: 'Cereal',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            underline: SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
            items: Grade.values.map((Grade grade) {
              return DropdownMenuItem<Grade>(
                value: grade, // Use the Grade enum directly as value
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: getColorForGrade(grade), // Get color based on the grade
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2), // Add white border
                      ),
                    ),
                    const SizedBox(width: 8), // Space between the color indicator and text
                    Text(grade.grade.split(" ")[0]), // Display only the trimmed grade (9th, 10th, etc.)
                  ],
                ),
              );
            }).toList(),
            onChanged: (Grade? newGrade) {
              if (newGrade != null) {
                setState(() {
                  selectedGrade = newGrade; // Update the selected grade
                });
                widget.onGradeChanged!(newGrade); // Call the callback with the new grade
              }
            },
          ),
      ],
      backgroundColor: selectedGrade == null ? Colors.blueAccent : selectedGrade?.fixedColor,
      centerTitle: true,
    );
  }
}
