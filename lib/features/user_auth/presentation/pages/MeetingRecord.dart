import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../global/common/document_list.dart';
import 'Tasks.dart';
import 'dart:async';
import 'package:myapp/global/common/Header.dart' as CommonHeader; // Import the common Header file

class MeetingRecordPage extends StatefulWidget {
  final Task task;

  const MeetingRecordPage({super.key, required this.task});

  @override
  _MeetingRecordPageState createState() => _MeetingRecordPageState();
}

class MeetingRecord {
  String docId;
  String date;
  String time;
  String discussionNotes;

  MeetingRecord({
    required this.docId,
    required this.date,
    required this.time,
    required this.discussionNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'date': date,
      'time': time,
      'discussionNotes': discussionNotes,
    };
  }
}

class _MeetingRecordPageState extends State<MeetingRecordPage> {
  String? userUUID;
  List<MeetingRecord> meetingRecords = [];
  StreamSubscription<QuerySnapshot>? _subscription;
  final Map<String, TextEditingController> _dateControllers = {};
  final Map<String, TextEditingController> _timeControllers = {};
  final Map<String, TextEditingController> _notesControllers = {};

  @override
  void initState() {
    super.initState();
    userUUID = FirebaseAuth.instance.currentUser?.uid;
    loadMeetingNotes();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _dateControllers.values.forEach((controller) => controller.dispose());
    _timeControllers.values.forEach((controller) => controller.dispose());
    _notesControllers.values.forEach((controller) => controller.dispose());
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
              CommonHeader.Header(dynamicText: "Meeting Record"),
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
    _dateControllers[record.docId] = TextEditingController(text: record.date);
    _timeControllers[record.docId] = TextEditingController(text: record.time);
    _notesControllers[record.docId] = TextEditingController(text: record.discussionNotes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          key: ValueKey(record.docId), // Ensure unique key for each record
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
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _dateControllers[record.docId],
                  key: ValueKey('${record.docId}-date'), // Unique key for each field
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
                  onTap: () => _selectDate(context, record),
                  onChanged: (value) {
                    updateMeetingRecord(record, date: value);
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _timeControllers[record.docId],
                  key: ValueKey('${record.docId}-time'), // Unique key for each field
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
                  onTap: () => _selectTime(context, record),
                  onChanged: (value) {
                    updateMeetingRecord(record, time: value);
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _notesControllers[record.docId],
                  key: ValueKey('${record.docId}-notes'), // Unique key for each field
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
                    updateMeetingRecord(record, discussionNotes: value);
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
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, MeetingRecord record) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = "${pickedDate.toLocal()}".split(' ')[0]; // Format date as YYYY-MM-DD
      setState(() {
        _dateControllers[record.docId]?.text = formattedDate;
      });
      updateMeetingRecord(record, date: formattedDate);
    }
  }

  Future<void> _selectTime(BuildContext context, MeetingRecord record) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      String formattedTime = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        _timeControllers[record.docId]?.text = formattedTime;
      });
      updateMeetingRecord(record, time: formattedTime);
    }
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
    var newRecordRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUUID)
        .collection('tasks')
        .doc(widget.task.id)
        .collection('meetingRecords')
        .doc();

    var newMeetingRecord = MeetingRecord(
      docId: newRecordRef.id,
      date: '',
      time: '',
      discussionNotes: '',
    );

    newRecordRef.set(newMeetingRecord.toMap());
  }

  void updateMeetingRecord(MeetingRecord record,
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
