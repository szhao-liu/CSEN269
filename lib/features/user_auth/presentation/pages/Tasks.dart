import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart' as CommonHeader;

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
  final String grade;

  TasksPage({required this.grade});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchAndSetTasks(widget.grade);
  }

  Future<void> fetchAndSetTasks(String grade) async {
    String? userUUID = FirebaseAuth.instance.currentUser?.uid;
    final querySnapshotTasks = await FirebaseFirestore.instance
        .collection('Checklist')
        .doc(grade)
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
              .set({'mark': false})
              .then((value) {
            print('Task added to user\'s tasks successfully');
          }).catchError((error) {
            print('Failed to add task to user\'s tasks: $error');
            // Handle the error as needed
          });
        }

        return Task(
            id: doc.id,
            title: doc['title'],
            description: doc['description'],
            mark: userTask != null ? userTask['mark'] : false,
            rank: doc['rank'] // Use null-aware operator to handle null value
        );
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

  void updateTaskMark(Task task, bool newValue) {
    setState(() {
      task.mark = newValue;
    });

    String? userUUID = FirebaseAuth.instance.currentUser?.uid;
    // Update mark in the user's collection
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(task.id)
        .set({'mark': newValue}, SetOptions(
        merge: true)) // Use set with merge to create if not exists or update if exists
        .then((value) {
      print('User task mark updated successfully');
    }).catchError((error) {
      print('Failed to update user task mark: $error');
      // Handle the error as needed
    });
  }


  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress(tasks);

    return Scaffold(

      body: Stack(
        children: [
      Positioned.fill(
      child: Image.asset(
        "assets/backgg.jpg",
        fit: BoxFit.cover,
      ),
    ),

    Padding(
        padding: EdgeInsets.all(16.0),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SizedBox(height: 70),

            Container(

              padding: EdgeInsets.all(0.0),

              child: CommonHeader.Header(dynamicText: "Tasks"),

              // child: Center(
              //   child: Text(
              //     'Tasks',
              //     style: TextStyle(
              //       color: Colors.indigo,
              //       fontSize: 30,
              //       fontWeight: FontWeight.bold,
              //       fontFamily: 'MadimiOne',
              //     ),
              //   ),
              // ),
            ),
            SizedBox(height: 40),
            LinearProgressIndicator(value: progress),


            Expanded(
              child: FrostedGlassBox(
                theWidth: double.infinity,
                theHeight: MediaQuery.of(context).size.height * 1.0,
                theChild: TaskList(
                  tasks: tasks,
                  grade: widget.grade,
                  updateTaskMark: updateTaskMark,
                ),
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


  class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final String grade;
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

class TaskCard extends StatelessWidget {
  final Task task;
  final String grade;
  final Function(Task, bool) updateTaskMark;

  TaskCard({required this.task, required this.grade, required this.updateTaskMark});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.0),
          color: Colors.green,
          child: Icon(Icons.add_card_rounded, color: Colors.white),
        ),
        onDismissed: (direction) {
          // Handle swipe action (optional)
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // Swipe right to open memo page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemoPage(task: task),
              ),
            );
          }
          return false;
        },
        child: ExpansionTile(
          title: Text(task.title,
              style: TextStyle(
              color: Colors.indigo,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'MadimiOne',)
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(task.description,style: TextStyle(
                color: Colors.indigo,
                fontSize: 15,
                fontWeight: FontWeight.normal,
                fontFamily: 'MadimiOne',)),
            ),
          ],
          trailing: Checkbox(
            value: task.mark,
            onChanged: (newValue) {
              if (newValue != null) {
                // Update Firestore document using the task's Id
                FirebaseFirestore.instance
                    .collection('Checklist')
                    .doc(grade)
                    .collection('tasks')
                    .doc(task.id)
                    .update({'mark': newValue})
                    .then((value) {
                  print('Document updated successfully');
                }).catchError((error) {
                  print('Failed to update document: $error');
                  // Handle the error as needed
                });
                // Call the function to update the task mark
                updateTaskMark(task, newValue);
              }
            },
          ),
        ),
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final int rank;
  bool mark;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.mark,
    required this.rank,
  });
}
