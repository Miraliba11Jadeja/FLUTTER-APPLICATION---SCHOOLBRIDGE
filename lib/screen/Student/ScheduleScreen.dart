import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleScreen extends StatefulWidget {
  final String className;

  ScheduleScreen({required this.className});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String selectedDay = 'Monday';
  String teacherName = '';  // Store the teacher name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.className} SCHEDULE'), // Use the class name in the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],
        backgroundColor: Color(0xFF134B70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DayButton(day: 'Monday', onPressed: updateSelectedDay),
                  SizedBox(width: 8),
                  DayButton(day: 'Tuesday', onPressed: updateSelectedDay),
                  SizedBox(width: 8),
                  DayButton(day: 'Wednesday', onPressed: updateSelectedDay),
                  SizedBox(width: 8),
                  DayButton(day: 'Thursday', onPressed: updateSelectedDay),
                  SizedBox(width: 8),
                  DayButton(day: 'Friday', onPressed: updateSelectedDay),
                  SizedBox(width: 8),
                  DayButton(day: 'Saturday', onPressed: updateSelectedDay),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Schedule')
                    .where('day', isEqualTo: selectedDay) // Filter by the selected day
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No schedule found for $selectedDay.'));
                  }

                  final scheduleData = snapshot.data!.docs[0].data() as Map<String, dynamic>;

                  // Fetch teacherName directly from the document
                  teacherName = scheduleData['teacherName'] ?? 'No Teacher';

                  // Check if periods is a Map, then convert it to a list
                  final periodsMap = scheduleData['periods'] as Map<String, dynamic>;

                  // Convert Map to List of Maps
                  final periodsList = periodsMap.entries.map((e) => e.value).toList();

                  // Filter periods by class name (e.g., '1A' or '1B')
                  final filteredPeriods = periodsList.where((period) {
                    final periodClass = period['class'] as String;
                    return periodClass == widget.className; // Match the selected class name
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredPeriods.length,
                    itemBuilder: (context, index) {
                      final period = filteredPeriods[index] as Map<String, dynamic>;

                      return ScheduleCard(
                        startTime: period['startTime'],
                        endTime: period['endTime'],
                        teacherName: teacherName,  // Use the teacher name here
                        subject: period['subject'],
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

  void updateSelectedDay(String day) {
    setState(() {
      selectedDay = day;
    });
  }
}

class DayButton extends StatelessWidget {
  final String day;
  final Function(String) onPressed;

  DayButton({required this.day, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(day),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF134B70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners for a rectangular button
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Adjust padding for better visibility
      ),
      child: Text(
        day, 
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String teacherName;
  final String subject;

  ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.teacherName,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.blueAccent),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start: $startTime', style: TextStyle(fontSize: 16)),
                Text('End: $endTime', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 8),
            Text('Teacher: $teacherName', style: TextStyle(fontSize: 16)),
            Text('Subject: $subject', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
