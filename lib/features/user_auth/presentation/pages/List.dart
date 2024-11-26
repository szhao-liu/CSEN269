import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../global/common/chat_window.dart';
import '../../../../global/common/document_list.dart';
import 'Tasks.dart';
import 'dart:async';
import 'package:college_finder/global/common/Header.dart' as CommonHeader;
import 'package:college_finder/global/common/Get_Help.dart';

class ListPage extends StatefulWidget {
  final Task task;

  const ListPage({super.key, required this.task});

  @override
  _ListPage createState() => _ListPage();
}

class MeetingRecord {
  String docId;
  String discussionNotes;
  List<MeetingEntry> entries;

  MeetingRecord({
    required this.docId,
    required this.discussionNotes,
    required this.entries,
  });

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'discussionNotes': discussionNotes,
      'entries': entries.map((e) => e.toMap()).toList(),
    };
  }
}

class MeetingEntry {
  String text;
  bool isChecked;

  MeetingEntry({required this.text, this.isChecked = false});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isChecked': isChecked,
    };
  }

  static MeetingEntry fromMap(Map<String, dynamic> map) {
    return MeetingEntry(
      text: map['text'] ?? '',
      isChecked: map['isChecked'] ?? false,
    );
  }
}

class _ListPage extends State<ListPage> {
  String? userUUID;
  List<MeetingRecord> meetingRecords = [];
  StreamSubscription<QuerySnapshot>? _subscription;
  final Map<String, TextEditingController> _notesControllers = {};
  final Map<String, TextEditingController> _entryControllers = {};

  @override
  void initState() {
    super.initState();
    userUUID = FirebaseAuth.instance.currentUser?.uid;
    loadMeetingNotes(); // Start real-time listener
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _notesControllers.values.forEach((controller) => controller.dispose());
    _entryControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Color(0xFFF9F9F9)),
          ),
          Column(
            children: [
              CommonHeader.Header(dynamicText: "List Entries", grade: widget.task.grade),
              SizedBox(height: 45),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Enter the accomplished tasks',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Cereal',
                              color: Colors.indigo,
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: meetingRecords.isEmpty
                                ? Center(
                              child: Text(
                                'No meeting records available',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cereal',
                                ),
                              ),
                            )
                                : ListView.builder(
                              itemCount: meetingRecords.length,
                              itemBuilder: (context, index) =>
                                  _buildMeetingRecordRow(
                                      meetingRecords[index]),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: addNewMeetingRecord,
                            icon: Icon(Icons.add),
                            label: Text('Add New Task'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    child: Text('References'),
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,  // Positioned to the bottom right
            child: GestureDetector(
              onTap: () {
                // Navigate to GetHelpPage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetHelpPage()),
                );
              },
              child: CircleAvatar(
                radius: 25, // Smaller size for the button
                backgroundColor: Colors.blueAccent,
                child: Text(
                  "?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,  // Adjusted font size for the "?" text
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => ChatWindow(
      //           userUUID: userUUID,
      //           grade: widget.task.grade,
      //         ),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.chat_rounded),
      //   backgroundColor: Color(0xFF0560FB),
      // ),
    );
  }

  Widget _buildMeetingRecordRow(MeetingRecord record) {
    // Ensure the controller for "discussionNotes" is initialized and updated
    if (_notesControllers[record.docId] == null) {
      _notesControllers[record.docId] =
          TextEditingController(text: record.discussionNotes);
    } else {
      _notesControllers[record.docId]?.text = record.discussionNotes;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: record.entries.map((entry) {
                      return CheckboxListTile(
                        title: Text(
                          entry.text,
                          style: TextStyle(fontFamily: 'Cereal'),
                        ),
                        value: entry.isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            entry.isChecked = value!;
                          });
                          updateMeetingRecord(record);
                        },
                        activeColor: Colors.indigo,
                        checkColor: Colors.white,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller:
                    _entryControllers[record.docId] ??= TextEditingController(),
                    key: ValueKey('${record.docId}-entry'),
                    decoration: InputDecoration(
                      hintText: 'Enter the completed task...',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: 'Cereal'),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cereal',
                    ),
                    onEditingComplete: () {
                      String entryText = _entryControllers[record.docId]
                          ?.text ?? '';
                      if (entryText.isNotEmpty) {
                        addNewEntry(record, entryText);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                removeMeetingRecord(record);
              },
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

    void loadMeetingNotes() {
    if (userUUID != null) {
      _subscription = FirebaseFirestore.instance
          .collection('users')
          .doc(userUUID)
          .collection('tasks')
          .doc(widget.task.id)
          .collection('meetingRecords')
          .snapshots()
          .listen((snapshot) {
        setState(() {
          meetingRecords = snapshot.docs.map((doc) {
            List<MeetingEntry> entries = (doc['entries'] as List?)
                ?.map((e) => MeetingEntry.fromMap(e))
                .toList() ?? [];

            return MeetingRecord(
              docId: doc.id,
              discussionNotes: doc['discussionNotes'] ?? '',
              entries: entries,
            );
          }).toList();

          // Update TextEditingController for each meeting record
          for (var record in meetingRecords) {
            if (_notesControllers[record.docId] == null) {
              _notesControllers[record.docId] = TextEditingController(text: record.discussionNotes);
            } else {
              _notesControllers[record.docId]?.text = record.discussionNotes;
            }
          }

          print("Meeting records retrieved: ${meetingRecords.length} records found");
        });
      }, onError: (error) {
        print("Error retrieving meeting records: $error");
      });
    }
  }

  void addNewMeetingRecord() {
    var newRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc();

    var newMeetingRecord = MeetingRecord(
      docId: newRecordRef.id,
      discussionNotes: '',
      entries: [],
    );

    newRecordRef.set(newMeetingRecord.toMap()).then((_) {
      print("New meeting record added with ID: ${newRecordRef.id}");
    }).catchError((error) {
      print("Failed to add new meeting record: $error");
    });
  }

  void addNewEntry(MeetingRecord record, String entryText) {
    var meetingRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc(record.docId);

    setState(() {
      record.entries.add(MeetingEntry(text: entryText));
      _entryControllers[record.docId]?.clear();
    });

    meetingRecordRef.update({
      'entries': record.entries.map((e) => e.toMap()).toList(),
    }).then((_) {
      print("New entry added to meeting record with ID: ${record.docId}");
    }).catchError((error) {
      print("Failed to add new entry: $error");
    });
  }

  void updateMeetingRecord(MeetingRecord record) {
    var meetingRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc(record.docId);

    meetingRecordRef.update(record.toMap()).then((_) {
      print("Meeting record updated for ID: ${record.docId}");
    }).catchError((error) {
      print("Failed to update meeting record: $error");
    });
  }


  void removeMeetingRecord(MeetingRecord record) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc(record.docId)
        .delete()
        .then((_) {
      print("Meeting record removed with ID: ${record.docId}");
    })
        .catchError((error) {
      print("Failed to remove meeting record: $error");
    });

    setState(() {
      meetingRecords.remove(record);
    });
  }
}
