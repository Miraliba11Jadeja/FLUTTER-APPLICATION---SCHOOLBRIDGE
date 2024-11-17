import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleDisplayScreen extends StatefulWidget {
  final String teacherName;

  ScheduleDisplayScreen({required this.teacherName, required List<QueryDocumentSnapshot<Map<String, dynamic>>> scheduleDocs});

  @override
  _ScheduleDisplayScreenState createState() => _ScheduleDisplayScreenState();
}

class _ScheduleDisplayScreenState extends State<ScheduleDisplayScreen> {
  String selectedDay = "Monday";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.teacherName}'s Schedule"),
        backgroundColor: Color(0xFF134B70),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDayTabs(),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Schedule')
                    .doc('${widget.teacherName}_$selectedDay')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text("No schedule available for $selectedDay"));
                  }

                  // Access periods from the document data
                  final scheduleData = snapshot.data!.data() as Map<String, dynamic>;
                  final periods = scheduleData['periods'] as Map<String, dynamic>;

                  final periodList = periods.entries.map((entry) {
                    return {
                      'period': entry.key,
                      ...entry.value as Map<String, dynamic>,
                    };
                  }).toList();

                  // Sort the list by period names or numbers if needed
                  periodList.sort((a, b) => a['period'].compareTo(b['period']));

                  return ListView.builder(
                    itemCount: periodList.length,
                    itemBuilder: (context, index) {
                      final periodData = periodList[index];
                      final isLunchBreak = periodData['subject'] == "Lunch Break";
                      final isFreePeriod = periodData['subject'] == "Free";

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
                                    isLunchBreak
                                        ? "Lunch Break"
                                        : isFreePeriod
                                            ? "Free Period"
                                            : "CLASS - ${periodData['class']}",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  if (isLunchBreak)
                                    Icon(Icons.restaurant, color: Colors.orange, size: 24)

                                    
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "${periodData['startTime']} - ${periodData['endTime']}",
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 4),
                              if (!isLunchBreak && !isFreePeriod)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      periodData['subject'] ?? 'No Subject',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      periodData['period'] ?? 'Period',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
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
                setState(() {
                  selectedDay = day;
                });
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

  void _editSchedule(BuildContext context, Map<String, dynamic> periodData, String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScheduleScreen(scheduleDoc: documentId, periodData: periodData),
      ),
    );
  }
}

class EditScheduleScreen extends StatelessWidget {
  final String scheduleDoc;
  final Map<String, dynamic> periodData;

  EditScheduleScreen({required this.scheduleDoc, required this.periodData});

  @override
  Widget build(BuildContext context) {
    final TextEditingController classController = TextEditingController(text: periodData['class']);
    final TextEditingController subjectController = TextEditingController(text: periodData['subject']);
    final TextEditingController periodController = TextEditingController(text: periodData['period']);
    final TextEditingController startTimeController = TextEditingController(text: periodData['startTime']);
    final TextEditingController endTimeController = TextEditingController(text: periodData['endTime']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Schedule"),
        backgroundColor: Color(0xFF134B70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: classController, decoration: InputDecoration(labelText: 'Class')),
            TextField(controller: subjectController, decoration: InputDecoration(labelText: 'Subject')),
            TextField(controller: periodController, decoration: InputDecoration(labelText: 'Period')),
            TextField(controller: startTimeController, decoration: InputDecoration(labelText: 'Start Time')),
            TextField(controller: endTimeController, decoration: InputDecoration(labelText: 'End Time')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveEdits(context, classController.text, subjectController.text, periodController.text, startTimeController.text, endTimeController.text);
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
    String classValue,
    String subject,
    String period,
    String startTime,
    String endTime,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('Schedule')
          .doc(scheduleDoc)
          .update({
        'periods.$period': {
          'class': classValue,
          'subject': subject,
          'startTime': startTime,
          'endTime': endTime,
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Schedule updated successfully")));
      Navigator.of(context).pop();
    } catch (e) {
      print("Failed to update schedule: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update schedule")));
    }
  }
}
