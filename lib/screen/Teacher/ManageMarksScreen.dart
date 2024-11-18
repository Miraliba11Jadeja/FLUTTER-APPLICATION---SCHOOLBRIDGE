import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_bridge_app/screen/Teacher/MarksTeacherScreen.dart';

class ManageMarksScreen extends StatefulWidget {
  @override
  _ManageMarksScreenState createState() => _ManageMarksScreenState();
}

class _ManageMarksScreenState extends State<ManageMarksScreen> {
  int? _selectedDistributions; // Number of distributions
  String? _selectedClass; // Selected class
  String? _selectedSubject; // Selected subject

  List<TextEditingController> _distributionNameControllers = [];
  List<TextEditingController> _totalMarksControllers = [];
  List<String> _classes = []; // List of class names
  List<String> _subjects = []; // List of subject names

  // Function to fetch class names from Firestore
  Future<void> _fetchClasses() async {
    final classSnapshot = await FirebaseFirestore.instance
        .collection('Class') // Assuming your collection is named 'Class'
        .get();
    setState(() {
      _classes = classSnapshot.docs
          .map((doc) => doc['Class'].toString()) // Replace with your field name
          .toList();
    });
  }

  // Function to fetch subject names from Firestore
  Future<void> _fetchSubjects() async {
    final subjectSnapshot = await FirebaseFirestore.instance
        .collection('Subject') // Assuming your collection is named 'Subject'
        .get();
    setState(() {
      _subjects = subjectSnapshot.docs
          .map((doc) => doc['Name'].toString()) // Replace with your field name
          .toList();
    });
  }

  // Function to dynamically add text fields based on number of distributions
  void _generateFields(int numberOfDistributions) {
    _distributionNameControllers = List.generate(
        numberOfDistributions, (index) => TextEditingController());
    _totalMarksControllers = List.generate(
        numberOfDistributions, (index) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    for (var controller in _distributionNameControllers) {
      controller.dispose();
    }
    for (var controller in _totalMarksControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Build the dynamic fields for inputting distribution names and total marks
  Widget _buildDynamicFields() {
    List<Widget> fields = [];
    for (int i = 0; i < _selectedDistributions!; i++) {
      fields.add(
        Column(
          children: [
            TextFormField(
              controller: _distributionNameControllers[i],
              decoration: InputDecoration(
                labelText: 'Name of Distribution ${i + 1}',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _totalMarksControllers[i],
              decoration: InputDecoration(
                labelText: 'Total Marks of ${i + 1}',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }
    return Column(children: fields);
  }

  // Function to calculate the total marks
  int _calculateTotalMarks() {
    int totalMarks = 0;
    for (var controller in _totalMarksControllers) {
      if (controller.text.isNotEmpty) {
        totalMarks += int.tryParse(controller.text) ?? 0;
      }
    }
    return totalMarks;
  }

  @override
  void initState() {
    super.initState();
    _fetchClasses(); // Fetch classes when the screen is initialized
    _fetchSubjects(); // Fetch subjects when the screen is initialized
  }

  // Function to save the data in Firestore
  Future<void> _saveMarksData() async {
    // Calculate the total marks
    int totalMarks = _calculateTotalMarks();

    // Prepare the data to be saved
    List<Map<String, dynamic>> distributions = [];
    for (int i = 0; i < _selectedDistributions!; i++) {
      distributions.add({
        'distribution_name': _distributionNameControllers[i].text,
        'total_marks': int.tryParse(_totalMarksControllers[i].text) ?? 0,
      });
    }

    // Save the data to Firestore
    await FirebaseFirestore.instance.collection('markslist').add({
      'class': _selectedClass,
      'subject': _selectedSubject,
      'distributions': distributions,
      'total_marks': totalMarks,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show a snackbar indicating the data is saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marks data saved successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Redirect to the MarksScreen after a short delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MarksScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('MANAGE MARKS'),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown to select class
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: InputDecoration(
                labelText: 'Select Class',
                border: OutlineInputBorder(),
              ),
              items: _classes.map((String className) {
                return DropdownMenuItem<String>(
                  value: className,
                  child: Text(className),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClass = newValue;
                });
              },
            ),
            SizedBox(height: 16),

            // Dropdown to select subject
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: InputDecoration(
                labelText: 'Select Subject',
                border: OutlineInputBorder(),
              ),
              items: _subjects.map((String subjectName) {
                return DropdownMenuItem<String>(
                  value: subjectName,
                  child: Text(subjectName),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSubject = newValue;
                });
              },
            ),
            SizedBox(height: 16),

            // Dropdown to select the number of distributions
            DropdownButtonFormField<int>(
              value: _selectedDistributions,
              decoration: InputDecoration(
                labelText: 'No of Distribution',
                border: OutlineInputBorder(),
              ),
              items: List.generate(10, (index) => index + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedDistributions = newValue;
                  if (_selectedDistributions != null) {
                    _generateFields(_selectedDistributions!);
                  }
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedDistributions != null) {
                  setState(() {
                    _generateFields(_selectedDistributions!);
                  });
                }
              },
              child: Text('ENTER'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF134B70),
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 90),
              ),
            ),
            SizedBox(height: 20),

            // Show the dynamic fields if the number of distributions is selected
            _selectedDistributions != null
                ? Expanded(
                    child: SingleChildScrollView(
                      child: _buildDynamicFields(),
                    ),
                  )
                : Container(),

            // Save Button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMarksData, // Call the save function
              child: Text('SAVE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF134B70),
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 90),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
