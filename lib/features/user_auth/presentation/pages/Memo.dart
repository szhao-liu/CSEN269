import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Tasks.dart';

class MemoPage extends StatefulWidget {
  final Task task;

  const MemoPage({Key? key, required this.task}) : super(key: key);

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  String? userUUID;
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get the current user's UUID
    userUUID = FirebaseAuth.instance.currentUser?.uid;
    // Load existing memo if available
    loadMemo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Task: ${widget.task.title}'),
            SizedBox(height: 30),
            TextField(
              controller: memoController,
              onChanged: (value) {
                // Save memo to Firestore whenever the text changes
                saveMemoToFirestore(value);
              },
              decoration: InputDecoration(
                hintText: 'Write your memo here...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }

  void loadMemo() {
    if (userUUID != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userUUID)
          .collection('tasks')
          .doc(widget.task.id)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            memoController.text = snapshot.data()?['memo'] ?? '';
          });
        }
      }).catchError((error) {
        print('Failed to load memo: $error');
      });
    }
  }

  void saveMemoToFirestore(String memo) {
    if (userUUID != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userUUID)
          .collection('tasks')
          .doc(widget.task.id)
          .set({'memo': memo}, SetOptions(merge: true))
          .then((value) {
        print('Memo saved to Firestore successfully');
      }).catchError((error) {
        print('Failed to save memo to Firestore: $error');
        // Handle the error as needed
      });
    }
  }

  @override
  void dispose() {
    // Dispose the memo controller to prevent memory leaks
    memoController.dispose();
    super.dispose();
  }
}
