import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../global/common/document_list.dart';
import 'Tasks.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader; // Import the common Header file

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
      body: Stack(
        children: [
          Image.asset(
            'assets/backgg.jpg', // Replace with your background image asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHeader.Header(dynamicText: "Memo"), // Use the Header from the common library
                Center(
                  child: Text(
                    'Task: ${widget.task.title}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontFamily: 'MadimiOne',
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 350, // Adjust the width as needed
                    child: TextField(
                      controller: memoController,
                      onChanged: (value) {
                        // Save memo to Firestore whenever the text changes
                        saveMemoToFirestore(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Write your memo here...',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.indigo,
                          fontFamily: 'MadimiOne',
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.indigo,
                        fontFamily: 'MadimiOne',
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                if (widget.task.documents.isNotEmpty)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocumentListPage(
                              documents: widget.task.documents,
                            ),
                          ),
                        );
                      },
                      child: Text('Help Needed?'),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
