import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Tasks.dart';
import 'dart:async';

class MeetingRecordPage extends StatefulWidget {
  final Task task;

  const MeetingRecordPage({Key? key, required this.task}) : super(key: key);

  @override
  _MeetingRecordPageState createState() => _MeetingRecordPageState();
}

class MeetingRecord {
  final String docId;
  final String date;
  final String time;
  final String discussionNotes;

  MeetingRecord({
    required this.docId,
    required this.date,
    required this.time,
    required this.discussionNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': "",
      'time': "",
      'discussionNotes': "",
    };
  }
}

class _MeetingRecordPageState extends State<MeetingRecordPage> {
  String? userUUID;
  List<MeetingRecord> meetingRecords = [];
  late StreamSubscription<QuerySnapshot> _subscription;

  @override
  void initState() {
    super.initState();
    userUUID = FirebaseAuth.instance.currentUser?.uid;
    loadMeetingNotes();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meeting Records')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: meetingRecords.isEmpty
            ? Center(
          child: Text('No meeting records available'),
        )
            : ListView.builder(
          itemCount: meetingRecords.length,
          itemBuilder: (context, index) => _buildMeetingRecordRow(meetingRecords[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewMeetingRecord();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMeetingRecordRow(MeetingRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text('Task Name: ${widget.task.title}'),
          subtitle: Text('Task Description: ${widget.task.description}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              removeMeetingRecord(record);
            },
          ),
        ),
        TextFormField(
          initialValue: record.date,
          decoration: InputDecoration(labelText: 'Date'),
          onChanged: (value) {
            updateMeetingRecordList(record, date: value);
          },
        ),
        TextFormField(
          initialValue: record.time,
          decoration: InputDecoration(labelText: 'Time'),
          onChanged: (value) {
            updateMeetingRecordList(record, time: value);
          },
        ),
        TextFormField(
          initialValue: record.discussionNotes,
          decoration: InputDecoration(labelText: 'Meeting-Notes'),
          maxLines: null,
          onChanged: (value) {
            updateMeetingRecordList(record, discussionNotes: value);
          },
        ),
      ],
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
          meetingRecords = snapshot.docs.map((doc) => MeetingRecord(
            docId: doc.id,
            date: doc['date'] ?? '',
            time: doc['time'] ?? '',
            discussionNotes: doc['discussionNotes'] ?? '',
          )).toList();
        });
      });
    }
  }

  void addNewMeetingRecord() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .add(MeetingRecord(
      docId: '',
      date: '',
      time: '',
      discussionNotes: '',
    ).toMap());
  }

  void updateMeetingRecordList(MeetingRecord record, {String? date, String? time, String? discussionNotes}) {
    var meetingRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc(record.docId);

    var updateData = <String, dynamic>{};
    if (date != null) updateData['date'] = date;
    if (time != null) updateData['time'] = time;
    if (discussionNotes != null) updateData['discussionNotes'] = discussionNotes;

    meetingRecordRef.update(updateData);
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
  }
}
