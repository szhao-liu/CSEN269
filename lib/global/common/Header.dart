import 'package:flutter/material.dart';
import '../../features/user_auth/presentation/pages/Student_choose_grade.dart';
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
          DropdownButton<dynamic>(
            value: selectedGrade,
            dropdownColor: Color(0xFFD9D9D9),
            style: TextStyle(
              fontFamily: 'Cereal',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            underline: SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
            items: [
              DropdownMenuItem<dynamic>(
                value: null,
                child: Row(
                  children: [
                    // Display small colored circles representing each grade
                    ...Grade.values.take(2).map((Grade grade) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: getColorForGrade(grade),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(width: 1),
                  ],
                ),
              ),
              ...Grade.values.map((Grade grade) {
                return DropdownMenuItem<Grade>(
                  value: grade,
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: getColorForGrade(grade),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(grade.grade.split(" ")[0]),
                    ],
                  ),
                );
              }).toList(),
            ],
            onChanged: (dynamic newGrade) {
              if (newGrade == null) {
                // Navigate to the StudentChooseGrade page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentChooseGrade()),
                );
              } else if (newGrade is Grade) {
                setState(() {
                  selectedGrade = newGrade;
                });
                widget.onGradeChanged!(newGrade);
              }
            },
          ),
      ],
      backgroundColor: selectedGrade == null ? Colors.blueAccent : selectedGrade?.fixedColor,
      centerTitle: true,
    );
  }
}
