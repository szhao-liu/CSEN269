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
      'discussionNotes': discussionNotes,
      'entries': entries.map((e) => e.toMap()).toList(),
    };
  }

  static MeetingRecord fromMap(DocumentSnapshot doc) {
    return MeetingRecord(
      docId: doc.id,
      discussionNotes: doc['discussionNotes'] ?? '',
      entries: (doc['entries'] as List?)
          ?.map((e) => MeetingEntry.fromMap(e))
          .toList() ??
          [],
    );
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
  final TextEditingController _entryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userUUID = FirebaseAuth.instance.currentUser?.uid;
    loadMeetingNotes(); // Start real-time listener
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFF9F9F9)),
          ),
          Column(
            children: [
              CommonHeader.Header(
                dynamicText: "List Entries",
                grade: widget.task.grade,
              ),
              const SizedBox(height: 45),
              Center(
                child: Text(
                  'Task: ${widget.task.title}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.indigo,
                    fontFamily: 'Cereal',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
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
                          const Text(
                            'Enter the accomplished tasks',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Cereal',
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: meetingRecords.isEmpty
                                ? const Center(
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
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: addNewMeetingRecord,
                            icon: const Icon(Icons.add),
                            label: const Text('Add New Task'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size.fromHeight(50),
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
              const SizedBox(height: 30),
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
                    child: const Text(
                      'References',
                      style: TextStyle(fontFamily: 'Cereal'),
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20, // Positioned to the bottom right
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GetHelpPage()),
                );
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent,
                child: Image.asset(
                  'assets/help.png', // Ensure this path is correct
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingRecordRow(MeetingRecord record) {
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
                  ...record.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(
                        entry.text,
                        style: const TextStyle(fontFamily: 'Cereal'),
                      ),
                      value: entry.isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          entry.isChecked = value ?? false;
                        });
                        updateMeetingRecord(record);
                      },
                      activeColor: Colors.indigo,
                      checkColor: Colors.white,
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _entryController,
                    decoration: const InputDecoration(
                      hintText: 'Enter the completed task...',
                      hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Cereal'),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        addNewEntry(record, value.trim());
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
              icon: const Icon(Icons.close),
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
          meetingRecords = snapshot.docs
              .map((doc) => MeetingRecord.fromMap(doc))
              .toList();
        });
      }, onError: (error) {
        print("Error retrieving meeting records: $error");
      });
    }
  }

  void addNewMeetingRecord() {
    final newRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc();

    final newMeetingRecord = MeetingRecord(
      docId: newRecordRef.id,
      discussionNotes: '',
      entries: [],
    );

    newRecordRef.set(newMeetingRecord.toMap()).catchError((error) {
      print("Failed to add new meeting record: $error");
    });
  }

  void addNewEntry(MeetingRecord record, String entryText) {
    final meetingRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc(record.docId);

    setState(() {
      record.entries.add(MeetingEntry(text: entryText));
    });

    meetingRecordRef.update(record.toMap()).catchError((error) {
      print("Failed to add new entry: $error");
    });

    _entryController.clear();
  }

  void updateMeetingRecord(MeetingRecord record) {
    final meetingRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc(record.docId);

    meetingRecordRef.update(record.toMap()).catchError((error) {
      print("Failed to update meeting record: $error");
    });
  }

  void removeMeetingRecord(MeetingRecord record) {
    final meetingRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc(record.docId);

    meetingRecordRef.delete().catchError((error) {
      print("Failed to delete meeting record: $error");
    });

    setState(() {
      meetingRecords.remove(record);
    });
  }
}
