import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddScheduleScreen extends StatefulWidget {
  final String teacherName;

  AddScheduleScreen({required this.teacherName});

  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Fixed period times
  final List<Map<String, String>> periods = [
    {"time": "08:15 am - 09:00 am", "label": "Period 1"},
    {"time": "09:00 am - 09:45 am", "label": "Period 2"},
    {"time": "09:45 am - 10:30 am", "label": "Period 3"},
    {"time": "11:00 am - 11:45 am", "label": "Period 4"},
  ];

  List<String> classes = [];
  List<String> subjects = ["Free"];
  Map<String, Map<String, String?>> selectedClass = {};
  Map<String, Map<String, String?>> selectedSubject = {};
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  int currentDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchClasses();
    _fetchSubjects();
  }

  Future<void> _fetchClasses() async {
    final classSnapshot = await FirebaseFirestore.instance.collection('Class').get();
    setState(() {
      classes = classSnapshot.docs.map((doc) => doc['Class'] as String).toList();
    });
  }

  Future<void> _fetchSubjects() async {
    final subjectSnapshot = await FirebaseFirestore.instance
        .collection('Teacher')
        .where('Name', isEqualTo: widget.teacherName)
        .get();

    setState(() {
      subjects.addAll(subjectSnapshot.docs
          .expand((doc) => List<String>.from(doc['Subjects']))
          .toList());
    });
  }

  Future<void> _saveScheduleForDay() async {
    if (_formKey.currentState!.validate()) {
      try {
        final selectedDay = days[currentDayIndex];
        for (int i = 0; i < periods.length; i++) {
          final period = periods[i];
          await FirebaseFirestore.instance.collection('Schedule').add({
            'teacherName': widget.teacherName,
            'class': selectedClass[selectedDay]?[period['label']] ?? '',
            'subject': selectedSubject[selectedDay]?[period['label']] ?? 'Free',
            'startTime': period['time']!.split(' - ')[0],
            'endTime': period['time']!.split(' - ')[1],
            'period': period['label'],
            'day': selectedDay,
          });
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$selectedDay schedule saved')),
        );

        if (currentDayIndex < days.length - 1) {
          // Move to the next day and reset the form
          setState(() {
            currentDayIndex++;
            selectedClass.clear();
            selectedSubject.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('All schedules added successfully')),
          );
        }
      } catch (e) {
        print("Error saving schedule: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save schedule: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = days[currentDayIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Schedule for $selectedDay"),
        backgroundColor: Color(0xFF134B70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: periods.length,
                  itemBuilder: (context, index) {
                    final period = periods[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${period['label']} - ${period['time']}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Select Class'),
                          items: classes.map((className) {
                            return DropdownMenuItem(
                              value: className,
                              child: Text(className),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedClass[selectedDay] ??= {};
                              selectedClass[selectedDay]![period['label']!] = value;
                            });
                          },
                          validator: (value) => value == null ? 'Please select a class' : null,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Select Subject'),
                          items: subjects.map((subject) {
                            return DropdownMenuItem(
                              value: subject,
                              child: Text(subject),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubject[selectedDay] ??= {};
                              selectedSubject[selectedDay]![period['label']!] = value;
                            });
                          },
                          validator: (value) => value == null ? 'Please select a subject' : null,
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveScheduleForDay,
        child: Icon(currentDayIndex < days.length - 1 ? Icons.arrow_forward : Icons.check),
        tooltip: currentDayIndex < days.length - 1 ? 'Next Day' : 'Submit Schedule',
        backgroundColor: Color(0xFF134B70),
      ),
    );
  }
}
