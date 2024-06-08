import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../global/common/document_list.dart';
import 'Tasks.dart';
import 'dart:async';
import 'package:myapp/global/common/Header.dart' as CommonHeader; // Import the common Header file

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
    loadMeetingNotes();
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
            child: Image.asset(
              'assets/backgg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              CommonHeader.Header(dynamicText: "List Entries"),
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
                              fontFamily: 'MadimiOne',
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
                    child: Text('Help Needed?'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingRecordRow(MeetingRecord record) {
    _notesControllers[record.docId] =
        TextEditingController(text: record.discussionNotes);

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
                        title: Text(entry.text),
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
                    controller: _entryControllers[record.docId] ??=
                        TextEditingController(),
                    key: ValueKey('${record.docId}-entry'),
                    decoration: InputDecoration(
                      hintText: 'Enter the completed task...',
                      hintStyle: TextStyle(color: Colors.grey),
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
                    ),
                    onFieldSubmitted: (value) {
                      addNewEntry(record, value);
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
            List<MeetingEntry> entries = [];
            if (doc['entries'] != null) {
              entries = (doc['entries'] as List)
                  .map((e) => MeetingEntry.fromMap(e))
                  .toList();
            }
            return MeetingRecord(
              docId: doc.id,
              discussionNotes: doc['discussionNotes'] ?? '',
              entries: entries,
            );
          }).toList();
        });
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

    newRecordRef.set(newMeetingRecord.toMap());
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
    });
  }

  void updateMeetingRecord(MeetingRecord record, {String? discussionNotes}) {
    var meetingRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc(record.docId);

    var updateData = <String, dynamic>{};
    if (discussionNotes != null) updateData['discussionNotes'] = discussionNotes;

    meetingRecordRef.update(updateData);

    setState(() {
      if (discussionNotes != null) record.discussionNotes = discussionNotes;
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
        .delete();

    setState(() {
      meetingRecords.remove(record);
    });
  }
}
