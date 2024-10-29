import 'package:college_finder/global/common/grade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../global/common/chat_window.dart';
import '../../../../global/common/document_list.dart';
import 'Tasks.dart';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;

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
    userUUID = FirebaseAuth.instance.currentUser?.uid;
    loadMemo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonHeader.Header(dynamicText: "Memo", grade: widget.task.grade),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Color(0xFFF9F9F9)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Task: ${widget.task.title}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontFamily: 'Cereal',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: memoController,
                        onChanged: (value) {
                          saveMemoToFirestore(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Write your memo here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo[300],
                            fontFamily: 'Cereal',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.indigo,
                          fontFamily: 'Cereal',
                        ),
                        maxLines: null,
                        minLines: 10,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Help Needed?',
                          style: TextStyle(fontFamily: 'Cereal')),
                    ),
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatWindow(
                userUUID: userUUID,
                grade: widget.task.grade,
              ),
            ),
          );
        },
        child: Icon(Icons.chat_rounded),
        backgroundColor: Color(0xFF0560FB),
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
          .set({'memo': memo}, SetOptions(merge: true)).then((value) {
        print('Memo saved to Firestore successfully');
      }).catchError((error) {
        print('Failed to save memo to Firestore: $error');
      });
    }
  }

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }
}
