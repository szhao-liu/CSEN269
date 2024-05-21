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
      'date': date,
      'time': time,
      'discussionNotes': discussionNotes,
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
              SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Meeting Notes',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Enter the details of the meeting',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                        _buildMeetingRecordRow(meetingRecords[index]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewMeetingRecord,
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  Widget _buildMeetingRecordRow(MeetingRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Task Name: ${widget.task.title}',
                //   style: TextStyle(
                //     color: Colors.indigo,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 20,
                //   ),
                // ),
                SizedBox(height: 8.0),
                TextFormField(
                  initialValue: record.date,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    labelStyle: TextStyle(color: Colors.indigo),
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
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    updateMeetingRecordList(record, date: value);
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  initialValue: record.time,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    labelStyle: TextStyle(color: Colors.indigo),
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
                  onChanged: (value) {
                    updateMeetingRecordList(record, time: value);
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  initialValue: record.discussionNotes,
                  decoration: InputDecoration(
                    labelText: 'Add meeting notes...',
                    labelStyle: TextStyle(color: Colors.indigo),
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
                  maxLines: null,
                  onChanged: (value) {
                    updateMeetingRecordList(record, discussionNotes: value);
                  },
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      removeMeetingRecord(record);
                    },
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
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
          meetingRecords = snapshot.docs
              .map((doc) => MeetingRecord(
            docId: doc.id,
            date: doc['date'] ?? '',
            time: doc['time'] ?? '',
            discussionNotes: doc['discussionNotes'] ?? '',
          ))
              .toList();
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

  void updateMeetingRecordList(MeetingRecord record,
      {String? date, String? time, String? discussionNotes}) {
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
