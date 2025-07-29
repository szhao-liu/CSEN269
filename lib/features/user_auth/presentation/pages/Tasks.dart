import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_finder/features/user_auth/presentation/pages/DocumentUpload.dart';
import 'package:college_finder/features/user_auth/presentation/pages/List.dart';
import 'package:college_finder/features/user_auth/presentation/pages/MeetingRecord.dart';
import 'package:college_finder/features/user_auth/presentation/pages/Video.dart';
import 'package:college_finder/global/common/Get_Help.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:college_finder/global/common/document_list.dart';
import 'package:college_finder/global/common/page_type.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../global/common/grade.dart';
import 'Memo.dart';

class FrostedGlassBox extends StatelessWidget {
  const FrostedGlassBox({
    Key? key,
    required this.theWidth,
    required this.theHeight,
    required this.theChild,
  }) : super(key: key);

  final double theWidth;
  final double theHeight;
  final Widget theChild;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: theWidth,
        height: theHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.13)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4.0,
            sigmaY: 4.0,
          ),
          child: Container(
            color: Colors.transparent,
            child: theChild,
          ),
        ),
      ),
    );
  }
}

class TasksPage extends StatefulWidget {
  Grade grade;

  TasksPage({required this.grade});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TickerProviderStateMixin {
  late List<Task> tasks = [];
  late AnimationController _tooltipController;
  late Animation<double> _tooltipAnimation;
  bool _showTooltip = true;

  @override
  void initState() {
    super.initState();
    fetchAndSetTasks(widget.grade);
    
    // Initialize tooltip animation
    _tooltipController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _tooltipAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _tooltipController,
      curve: Curves.easeInOut,
    ));
    
    // Show tooltip and fade after 5 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: 5), () {
        if (mounted) {
          _tooltipController.forward().then((_) {
            setState(() {
              _showTooltip = false;
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _tooltipController.dispose();
    super.dispose();
  }

  void _onGradeChanged(Grade newGrade) {
    setState(() {
      widget.grade = newGrade;
      fetchAndSetTasks(widget.grade);
    });
  }

  Future<void> fetchAndSetTasks(Grade grade) async {
    String? userUUID = FirebaseAuth.instance.currentUser?.uid;
    final querySnapshotTasks = await FirebaseFirestore.instance
        .collection('Checklist')
        .doc(grade.grade)
        .collection('tasks')
        .get();

    final querySnapshotUsers = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .get();

    setState(() {
      tasks = querySnapshotTasks.docs.map((doc) {
        // Find the corresponding mark from querySnapshotUsers
        var userTask;
        querySnapshotUsers.docs.forEach((userTaskDoc) {
          if (userTaskDoc.id == doc.id) {
            userTask = userTaskDoc;
          }
        });

        // If userTask is null, add the task to user's tasks with mark false
        if (userTask == null) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userUUID)
              .collection('tasks')
              .doc(doc.id)
              .set({'mark': false}).then((value) {
            print('Task added to user\'s tasks successfully');
          }).catchError((error) {
            print('Failed to add task to user\'s tasks: $error');
            // Handle the error as needed
          });
        }

        List<String> documents = [];
        List<String> links = [];
        try {
          documents = List<String>.from(doc['documents']);
        } catch (e) {
          // Handle the exception, for example, print an error message
          print('Error fetching documents: $e');
          // You can also log the error or perform any other error handling as needed
        }

        try {
          links = List<String>.from(doc['link']);
        } catch (e) {
          // Handle the exception, for example, print an error message
          print('Error fetching links: $e');
          // You can also log the error or perform any other error handling as needed
        }

        return Task(
            id: doc.id,
            title: doc['title'],
            description: doc['description'],
            mark: userTask != null ? userTask['mark'] : false,
            pageType: PageTypeHelper.fromStringValue(doc['page_type']),
            rank: doc['rank'],
            // Use null-aware operator to handle null value
            documents: documents,
            links: links,
            grade: grade);
      }).toList();

      // Sort the tasks based on rank
      tasks.sort((a, b) => a.rank.compareTo(b.rank));
    });
  }

  double calculateProgress(List<Task> tasks) {
    if (tasks.isEmpty) return 0.0;

    int completedTasks = tasks
        .where((task) => task.mark)
        .length;
    return completedTasks / tasks.length;
  }

  void _showCompletionPopup() {
    String message = _getCompletionMessage(widget.grade.grade);

    // Get the color from the grade's fixedColor property
    Color gradeColor = widget.grade.fixedColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: gradeColor, // Dynamically set the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          title: Text(
            "CONGRATULATIONS",
            style: TextStyle(
              fontSize: 24, // Customize font size
              fontWeight: FontWeight.bold, // Customize font weight
              color: Colors.black, // White color for title text
            ),
            textScaler:  MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 18, // Customize font size
              color: Colors.black, // Lighter text color for message content
            ),
            textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  fontSize: 16, // Customize font size
                  fontWeight: FontWeight.w600, // Customize font weight
                  color: Colors.black, // Button text color
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getCompletionMessage(String grade) {
    return "You did it !!! You completed the checklist for this year!";
  }

  void updateTaskMark(Task task, bool newValue) {
    setState(() {
      task.mark = newValue;
    });

    String? userUUID = FirebaseAuth.instance.currentUser?.uid;

    // Update mark in Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(task.id)
        .set({'mark': newValue}, SetOptions(merge: true))
        .then((value) {
      print('User task mark updated successfully');

      // Check if all tasks are completed and show popup
      if (tasks.every((task) => task.mark)) {
        _showCompletionPopup();
      }
    }).catchError((error) {
      print('Failed to update user task mark: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress(tasks);
    int completedTasks = tasks.where((task) => task.mark).length;
    int totalTasks = tasks.length;
    double progressPercent = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    return Scaffold(
      appBar: CommonHeader.Header(
        dynamicText: "Checklist",
        grade: widget.grade,
        onGradeChanged: _onGradeChanged,
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Color(0xFFF9F9F9)),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      widget.grade.grade,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Cereal",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      children: [
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.lightGreen.withOpacity(0.3),
                          ),
                        ),
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 12.0),
                              child: Text(
                                '${progressPercent.toStringAsFixed(0)}%',
                                textScaler: TextScaler.noScaling,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Progress',
                    style: TextStyle(
                      fontFamily: 'Cereal',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  FrostedGlassBox(
                    theWidth: double.infinity,
                    theHeight: MediaQuery.of(context).size.height * 0.7,
                    theChild: TaskList(
                      tasks: tasks,
                      grade: widget.grade,
                      updateTaskMark: updateTaskMark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              // Hide tooltip immediately when tapped
              if (_showTooltip) {
                _tooltipController.forward().then((_) {
                  setState(() {
                    _showTooltip = false;
                  });
                });
              }
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GetHelpPage()),
              );
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueAccent,
              child: Image.asset(
                'assets/help.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Tooltip bubble
          if (_showTooltip)
            Positioned(
              bottom: 70, // Position above the FAB
              right: -40, // Center above the button
              child: FadeTransition(
                opacity: _tooltipAnimation,
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Cereal',
                          ),
                          children: [
                            TextSpan(text: "Click here if you need help on how to use the checklist "),
                            TextSpan(
                              text: "👇",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Custom painter for the triangle arrow
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, size.height); // Bottom center
    path.lineTo(0, 0); // Top left
    path.lineTo(size.width, 0); // Top right
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Grade grade;
  final Function(Task, bool) updateTaskMark;

  TaskList({
    required this.tasks,
    required this.grade,
    required this.updateTaskMark,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(
          task: tasks[index],
          grade: grade,
          updateTaskMark: updateTaskMark,
        );
      },
    );
  }
}

Widget getPageWidget(Task task) {
  switch (task.pageType) {
    case PageType.memo:
      return MemoPage(task: task);
    case PageType.video:
      return VideoPage(task: task);
    case PageType.docUpload:
      return DocumentUploadPage(task: task);
    case PageType.dateTime:
      return MeetingRecordPage(task: task);
    case PageType.list:
      return ListPage(task: task);
    case PageType.docList:
      return DocumentListPage(documents: task.documents);
  // Add cases for other page types if needed
    default:
      return DocumentUploadPage(task: task);
  //return MemoPage(task: task); // Return a default page or show an error message if the page type is not recognized
  }
}

class TaskCard extends StatefulWidget {
  final Task task;
  final Grade grade;
  final Function(Task, bool) updateTaskMark;

  TaskCard({
    required this.task,
    required this.grade,
    required this.updateTaskMark,
  });

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _arrowController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _arrowAnimation;
  late Timer? _timer;
  bool _isAnimationStopped = false;
  bool _isExpanded = false; // Track expansion state

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _arrowAnimation = Tween<double>(
      begin: 0.0,
      end: -10.0,
    ).animate(CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeInOut,
    ));

    // Start animations once and stop them after completion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward().then((_) {
        _controller.reverse().then((_) {
          setState(() {
            _isAnimationStopped = true;
          });
        });
      });
      
      _arrowController.forward().then((_) {
        _arrowController.reverse();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Dismissible(
        key: Key(widget.task.id),
        direction: DismissDirection.endToStart,
        background: Stack(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              color: Colors.green,
              child: Icon(Icons.add_card_rounded, color: Colors.white),
            ),
            Positioned.fill(
              right: 20.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white.withOpacity(0.6),
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        onDismissed: (direction) {
          // Handle swipe action (optional)
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => getPageWidget(widget.task),
              ),
            );
          }
          return false; // Prevents dismissal when navigating
        },
        child: SlideTransition(
          position: _offsetAnimation,
          child: _buildCustomTile(context),
        ),
      ),
    );
  }

  Widget _buildCustomTile(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Title row with tight control over spacing
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12), // Reduced right padding
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.task.title,
                      style: TextStyle(
                        color: Color(0xFF0560FB),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cereal',
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
                    ),
                  ),
                  // Arrows with no extra spacing
                  !_isAnimationStopped
                      ? AnimatedBuilder(
                          animation: _arrowAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_arrowAnimation.value, 0),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Color(0xFF0560FB).withOpacity(0.7),
                                size: 20,
                              ),
                            );
                          },
                        )
                      : Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF0560FB).withOpacity(0.4),
                          size: 20,
                        ),
                  !_isAnimationStopped
                      ? AnimatedBuilder(
                          animation: _arrowAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_arrowAnimation.value, 0),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Color(0xFF0560FB).withOpacity(0.7),
                                size: 20,
                              ),
                            );
                          },
                        )
                      : Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF0560FB).withOpacity(0.4),
                          size: 20,
                        ),
                  SizedBox(width: 4), // Minimal gap
                  // Checkbox with minimal spacing
                  Checkbox(
                      value: widget.task.mark,
                      activeColor: Color(0xFF0560FB),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          FirebaseFirestore.instance
                              .collection('Checklist')
                              .doc(widget.grade.grade)
                              .collection('tasks')
                              .doc(widget.task.id)
                              .update({'mark': newValue}).then((value) {
                            print('Document updated successfully');
                          }).catchError((error) {
                            print('Failed to update document: $error');
                          });
                          widget.updateTaskMark(widget.task, newValue);
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
          // Expandable content
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.task.description,
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 15,
                        fontFamily: 'Cereal',
                      ),
                      textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class TaskListPage extends StatelessWidget {
  final List<Task> tasks;
  final Grade grade;

  TaskListPage({required this.tasks, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Swipe right on a task to open its memo page',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: tasks[index],
                  grade: grade,
                  updateTaskMark: (task, newValue) {
                    // Your updateTaskMark implementation here
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final int rank;
  final PageType pageType;
  final List<String> documents;
  final List<String> links;
  final Grade grade;
  bool mark;

  Task({required this.id,
    required this.title,
    required this.description,
    required this.mark,
    required this.pageType,
    required this.rank,
    required this.grade,
    required this.links,
    required this.documents});
}