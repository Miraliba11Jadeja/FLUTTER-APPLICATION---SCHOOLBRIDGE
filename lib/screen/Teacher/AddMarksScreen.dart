import 'package:flutter/material.dart';
import 'package:school_bridge_app/screen/Teacher/AddMarksScreenProceed.dart';

void main() {
  runApp(AddMarksApp());
}

class AddMarksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddMarksScreen(),
    );
  }
}

class AddMarksScreen extends StatefulWidget {
  @override
  _AddMarksScreenState createState() => _AddMarksScreenState();
}

class _AddMarksScreenState extends State<AddMarksScreen> {
  String? selectedClass;
  String? selectedSection;
  String? selectedSubject;
  String? selectedType;
  String? selectedExam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70), // Dark Blue color
        title: Text('ADD MARKS'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Handle menu press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildDropdownButton('Select Class',
                ['Class 1', 'Class 2', 'Class 3'], selectedClass, (value) {
              setState(() {
                selectedClass = value;
              });
            }),
            SizedBox(height: 16),
            buildDropdownButton(
                'Select Section', ['A', 'B', 'C'], selectedSection, (value) {
              setState(() {
                selectedSection = value;
              });
            }),
            SizedBox(height: 16),
            buildDropdownButton('Select Subject',
                ['Math', 'Science', 'English'], selectedSubject, (value) {
              setState(() {
                selectedSubject = value;
              });
            }),
            SizedBox(height: 16),
            buildDropdownButton(
                'Select Type', ['Assignment', 'Quiz'], selectedType, (value) {
              setState(() {
                selectedType = value;
              });
            }),
            SizedBox(height: 16),
            buildDropdownButton(
                'Select Exam', ['Midterm', 'Final'], selectedExam, (value) {
              setState(() {
                selectedExam = value;
              });
            }),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF134B70), // Dark Blue color for the button
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMarksScreenProceed()));
                // Handle proceed button press
              },
              child: Center(
                child: Text(
                  'PROCEED',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownButton(String hintText, List<String> items,
      String? selectedItem, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF134B70), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      value: selectedItem,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }
}
