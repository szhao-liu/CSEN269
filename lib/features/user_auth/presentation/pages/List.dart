import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Tasks.dart'; // Import the Task class
import 'package:myapp/global/common/Header.dart' as CommonHeader; // Import the common Header file

class TaskListPage extends StatefulWidget {
  final Task task;
  const TaskListPage({Key? key, required this.task}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<SubTask> subTasks = []; // Changed the name to subTasks

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.Header(dynamicText: "List"), //,
      body: ListView.builder(
        itemCount: subTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subTasks[index].name), // Display task name
            subtitle: Text(subTasks[index].description), // Display task description as subtitle
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add task
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        // Update task name
                      },
                      decoration: InputDecoration(labelText: 'Task Name'),
                    ),
                    TextField(
                      onChanged: (value) {
                        // Update task description
                      },
                      decoration: InputDecoration(labelText: 'Task Description'),
                    ),
                  ],
                ),
                actions: [
                  CupertinoButton(
                    onPressed: () {
                      // Add task to the list
                      setState(() {
                        subTasks.add(SubTask(
                          name: 'New Task',
                          description: 'Task Description',
                        ));
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SubTask{
  String name;
  String description;
  SubTask({
   required this.name,
   required this.description,
  });
}