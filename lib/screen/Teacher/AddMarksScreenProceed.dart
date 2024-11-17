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

  @override
  void initState() {
    super.initState();
    selectedClass = widget.selectedClass;
    selectedSubject = widget.selectedSubject;
    selectedType = widget.selectedType;
    selectedExam = widget.selectedExam;

    // Fetch students' data from Firestore when the screen is initialized
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
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
          .where('ClassName', isEqualTo: selectedClass)
          .where('SubjectName', isEqualTo: selectedSubject)
          .get();

      if (studentQuery.docs.isEmpty || marksQuery.docs.isEmpty) {
        print(
            "No data found for the class: $selectedClass and subject: $selectedSubject");
        return;
      }

      // Extract distribution names from the fetched markslist
      List<String> distributions = [];
      for (var doc in marksQuery.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('Distributions')) {
          for (var dist in data['Distributions']) {
            distributions.add(dist['DistributionName']);
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
          for (var dist in distributions) {
            marksControllers[dist] = TextEditingController(text: '0');
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
        print("Students and distributions fetched successfully.");
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void saveMarks() async {
    List<Map<String, dynamic>> savedMarks = students.map((student) {
      Map<String, int> marks = {}; // To hold individual distribution marks
      int totalMarks = 0; // To hold the total marks for the student

      student['marks'].forEach((key, controller) {
        int mark = int.tryParse(controller.text) ?? 0;
        marks[key] = mark; // Save the marks for each distribution
        totalMarks += mark; // Add to the total marks (scored marks)
      });

      return {
        'sno': student['sno'],
        'name': student['name'],
        'marks': marks, // Save marks for all distributions
        'totalMarks': totalMarks, // Save the total marks for the student
      };
    }).toList();

    // Save data to Firestore
    try {
      for (var studentMarks in savedMarks) {
        // Save each student's marks in the Firestore collection 'Marks'
        await FirebaseFirestore.instance.collection('Marks').add({
          'class': selectedClass,
          'subject': selectedSubject,
          'exam': selectedExam,
          'type': selectedType,
          'sno': studentMarks['sno'],
          'name': studentMarks['name'],
          'marks': studentMarks['marks'],
          'totalMarks': studentMarks['totalMarks'], // Save total marks
          'timestamp': FieldValue
              .serverTimestamp(), // To store the time the document was created
        });
      }

      // Calculate the total marks for the entire class
      int classTotalMarks = savedMarks.fold(0, (int sum, student) {
        return sum + (student['totalMarks'] as int);
      });

      // Save the total marks for the class in a separate document or collection
      await FirebaseFirestore.instance
          .collection('ClassTotals')
          .doc(selectedClass)
          .set({
        'class': selectedClass,
        'subject': selectedSubject,
        'exam': selectedExam,
        'totalMarks':
            classTotalMarks, // Total marks for all students in the class
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show a success message after saving the data
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Marks saved successfully!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      // Handle any errors during the saving process
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
                Text('${selectedClass}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${selectedExam}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${selectedSubject}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${selectedType}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(
                        label: Text('SNo',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    ...students.isNotEmpty && students[0]['marks'] != null
                        ? students[0]['marks'].keys.map((distName) {
                            return DataColumn(
                                label: Text(distName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)));
                          }).toList()
                        : [], // If marks are null, no distribution columns will be shown
                    DataColumn(
                        label: Text('Total Marks',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: students.map((student) {
                    return DataRow(cells: [
                      DataCell(Text(student['sno'].toString())),
                      DataCell(Text(student['name'])),
                      ...student['marks'] != null
                          ? student['marks'].keys.map((distName) {
                              return DataCell(_buildMarksInputField(
                                  student['marks'][distName]));
                            }).toList()
                          : [], // If marks are null, no cells will be rendered
                      DataCell(Text(student['totalMarks']
                          .toString())), // Display the total marks for the student
                    ]);
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF134B70),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: saveMarks,
              child: Text(
                'SAVE',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarksInputField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
