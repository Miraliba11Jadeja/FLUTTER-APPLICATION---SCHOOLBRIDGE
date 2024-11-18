import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMarksScreenProceed extends StatefulWidget {
  final String selectedClass;
  final String selectedSubject;
  final String selectedType;
  final String selectedExam;

  AddMarksScreenProceed({
    required this.selectedClass,
    required this.selectedSubject,
    required this.selectedType,
    required this.selectedExam,
  });

  @override
  _AddMarksScreenProceedState createState() => _AddMarksScreenProceedState();
}

class _AddMarksScreenProceedState extends State<AddMarksScreenProceed> {
  String? selectedClass;
  String? selectedSubject;
  String? selectedType;
  String? selectedExam;

  // List to store students' data fetched from Firestore
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> distributions = [];

  @override
  void initState() {
    super.initState();
    selectedClass = widget.selectedClass;
    selectedSubject = widget.selectedSubject;
    selectedType = widget.selectedType;
    selectedExam = widget.selectedExam;

    // Fetch students' data and distributions when the screen is initialized
    _fetchStudentsAndDistributions();
  }

  Future<void> _fetchStudentsAndDistributions() async {
    try {
      print("Fetching students for class: $selectedClass");

      // Fetch students for the selected class
      QuerySnapshot studentQuery = await FirebaseFirestore.instance
          .collection('Student')
          .where('Class', isEqualTo: selectedClass)
          .get();

      print("Students query completed.");

      // Fetch the distributions for the selected class and subject
      QuerySnapshot marksQuery = await FirebaseFirestore.instance
          .collection('markslist')
          .where('class', isEqualTo: selectedClass)
          .where('subject', isEqualTo: selectedSubject)
          .get();

      if (studentQuery.docs.isEmpty || marksQuery.docs.isEmpty) {
        print("No data found for the class: $selectedClass and subject: $selectedSubject");
        return;
      }

      // Extract distributions from the fetched markslist
      List<Map<String, dynamic>> fetchedDistributions = [];
      for (var doc in marksQuery.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('distributions')) {
          for (var dist in data['distributions']) {
            fetchedDistributions.add({
              'name': dist['distribution_name'],
              'totalMarks': dist['total_marks'] ?? 0,
            });
          }
        }
      }

      // Build the student list with dynamic fields for distributions
      List<Map<String, dynamic>> studentList = [];
      int index = 1;

      for (var doc in studentQuery.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('Name') && data['Name'] != null) {
          Map<String, TextEditingController> marksControllers = {};
          for (var dist in fetchedDistributions) {
            marksControllers[dist['name']] = TextEditingController(text: '0');
          }

          studentList.add({
            'sno': index,
            'name': data['Name'],
            'marks': marksControllers, // Dynamic controllers for distributions
          });
          index++;
        }
      }

      setState(() {
        students = studentList;
        distributions = fetchedDistributions; // Store distributions for later use
        print("Students and distributions fetched successfully.");
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

Future<void> saveMarks() async {
  try {
    List<Map<String, dynamic>> savedMarks = students.map((student) {
      Map<String, int> marks = {};
      int totalMarks = 0;

      student['marks'].forEach((key, controller) {
        int mark = int.tryParse(controller.text) ?? 0;
        marks[key] = mark;
        totalMarks += mark;
      });

      return {
        'sno': student['sno'],
        'name': student['name'],
        'marks': marks,
        'totalMarks': totalMarks,
      };
    }).toList();

    print("Saving Marks Data: $savedMarks");

    for (var studentMarks in savedMarks) {
      await FirebaseFirestore.instance.collection('Marks').add({
        'class': selectedClass,
        'subject': selectedSubject,
        'exam': selectedExam,
        'type': selectedType,
        'sno': studentMarks['sno'],
        'name': studentMarks['name'],
        'marks': studentMarks['marks'],
        'totalMarks': studentMarks['totalMarks'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    int classTotalMarks = savedMarks.fold(0, (sum, student) => sum + (student['totalMarks'] as int));

    await FirebaseFirestore.instance.collection('ClassTotals').doc(selectedClass).set({
      'class': selectedClass,
      'subject': selectedSubject,
      'exam': selectedExam,
      'totalMarks': classTotalMarks,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Marks saved successfully!'),
      backgroundColor: Colors.green,
    ));
  } catch (e) {
    print("Error saving marks: $e");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to save marks. Please try again.'),
      backgroundColor: Colors.red,
    ));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('ADD MARKS'),
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
              // Handle menu button press if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${selectedClass}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${selectedExam}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${selectedSubject}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${selectedType}', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(label: Text('SNo', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    ...distributions.isNotEmpty
                        ? distributions.map((dist) {
                            return DataColumn(
                              label: Text('${dist['name']} (${dist['totalMarks']})', style: TextStyle(fontWeight: FontWeight.bold)),
                            );
                          }).toList()
                        : [],
                  ],
                  rows: students.map((student) {
                    return DataRow(cells: [
                      DataCell(Text(student['sno'].toString())),
                      DataCell(Text(student['name'])),
                      ...distributions.map((dist) {
                        return DataCell(_buildMarksInputField(student['marks'][dist['name']])); 
                      }).toList(),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF134B70),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              onPressed: saveMarks,
              child: Text('Save Marks', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarksInputField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '0',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
