import 'package:flutter/material.dart';

enum Grade {
  ninth,
  tenth,
  eleventh,
  twelfth,
}

// Extension to add properties to the Grade enum
extension GradeExtension on Grade {
  String get grade {
    switch (this) {
      case Grade.ninth:
        return '9th Grade';
      case Grade.tenth:
        return '10th Grade';
      case Grade.eleventh:
        return '11th Grade';
      case Grade.twelfth:
        return '12th Grade';
    }
  }

  Color get fixedColor {
    switch (this) {
      case Grade.ninth:
        return Colors.red[200]!;
      case Grade.tenth:
        return Colors.blue[200]!;
      case Grade.eleventh:
        return Colors.green[200]!;
      case Grade.twelfth:
        return Colors.orange[200]!;
    }
  }
}

Color getColorForGrade(Grade grade) {
  return grade.fixedColor;
}

// Helper method to get Grade from a string
Grade getGradeFromString(String grade) {
  switch (grade) {
    case '9th Grade':
      return Grade.ninth;
    case '10th Grade':
      return Grade.tenth;
    case '11th Grade':
      return Grade.eleventh;
    case '12th Grade':
      return Grade.twelfth;
    default:
      throw ArgumentError('Unknown grade: $grade');
  }
}
