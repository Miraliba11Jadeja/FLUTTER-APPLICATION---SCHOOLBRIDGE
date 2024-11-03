import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleDisplayScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot> scheduleDocs;
  final String teacherName; // Add this to pass the teacher's name

  ScheduleDisplayScreen({required this.scheduleDocs, required this.teacherName});

  @override
  _ScheduleDisplayScreenState createState() => _ScheduleDisplayScreenState();
}

class _ScheduleDisplayScreenState extends State<ScheduleDisplayScreen> {
  String selectedDay = "Monday"; // Default selected day
  List<QueryDocumentSnapshot> filteredScheduleDocs = [];

  @override
  void initState() {
    super.initState();
    _filterScheduleByDay(selectedDay);
  }

  void _filterScheduleByDay(String day) {
    setState(() {
      filteredScheduleDocs = widget.scheduleDocs.where((doc) {
        final scheduleData = doc.data() as Map<String, dynamic>;
        return scheduleData['day'] == day; // Assuming 'day' is a field in Firestore
      }).toList();
      selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.teacherName}'s Schedule"), // Use teacher's name in title
        backgroundColor: Color(0xFF134B70),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Add menu functionality here if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDayTabs(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredScheduleDocs.length,
                itemBuilder: (context, index) {
                  final scheduleData = filteredScheduleDocs[index].data() as Map<String, dynamic>;
                  final isLunchBreak = scheduleData['period'] == "Lunch Break";

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blue.shade200, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isLunchBreak ? "Lunch Break" : "CLASS - ${scheduleData['class']}",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (isLunchBreak)
                                Icon(Icons.restaurant, color: Colors.orange, size: 24)
                              else
                                IconButton(
                                  icon: Icon(Icons.edit, color: Color(0xFF134B70)),
                                  onPressed: () {
                                    _editSchedule(context, filteredScheduleDocs[index]);
                                  },
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${scheduleData['startTime']} - ${scheduleData['endTime']}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 4),
                          if (!isLunchBreak)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  scheduleData['subject'] ?? 'No Subject',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  scheduleData['period'] ?? 'Period',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"].map((day) {
            return GestureDetector(
              onTap: () {
                _filterScheduleByDay(day);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: selectedDay == day ? Color(0xFF134B70) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  day,
                  style: TextStyle(
                    color: selectedDay == day ? Colors.white : Colors.black,
                    fontWeight: selectedDay == day ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _editSchedule(BuildContext context, QueryDocumentSnapshot doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScheduleScreen(scheduleDoc: doc),
      ),
    );
  }
}

class EditScheduleScreen extends StatelessWidget {
  final QueryDocumentSnapshot scheduleDoc;

  EditScheduleScreen({required this.scheduleDoc});

  @override
  Widget build(BuildContext context) {
    final scheduleData = scheduleDoc.data() as Map<String, dynamic>;
    final TextEditingController classController = TextEditingController(text: scheduleData['class']);
    final TextEditingController subjectController = TextEditingController(text: scheduleData['subject']);
    final TextEditingController periodController = TextEditingController(text: scheduleData['period']);
    final TextEditingController startTimeController = TextEditingController(text: scheduleData['startTime']);
    final TextEditingController endTimeController = TextEditingController(text: scheduleData['endTime']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Schedule"),
        backgroundColor: Color(0xFF134B70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: classController,
              decoration: InputDecoration(labelText: 'Class'),
            ),
            TextField(
              controller: subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: periodController,
              decoration: InputDecoration(labelText: 'Period'),
            ),
            TextField(
              controller: startTimeController,
              decoration: InputDecoration(labelText: 'Start Time'),
            ),
            TextField(
              controller: endTimeController,
              decoration: InputDecoration(labelText: 'End Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveEdits(
                  context,
                  scheduleDoc,
                  classController.text,
                  subjectController.text,
                  periodController.text,
                  startTimeController.text,
                  endTimeController.text,
                );
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEdits(
    BuildContext context,
    QueryDocumentSnapshot doc,
    String classValue,
    String subject,
    String period,
    String startTime,
    String endTime,
  ) async {
    try {
      await doc.reference.update({
        'class': classValue,
        'subject': subject,
        'period': period,
        'startTime': startTime,
        'endTime': endTime,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Schedule updated successfully")));
      Navigator.of(context).pop();
    } catch (e) {
      print("Failed to update schedule: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update schedule")));
    }
  }
}
