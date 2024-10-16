import 'package:flutter/material.dart';

void main() {
  runApp(AddMarksApp());
}

class AddMarksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddMarksScreenProceed(),
    );
  }
}

class AddMarksScreenProceed extends StatefulWidget {
  @override
  _AddMarksScreenProceedState createState() => _AddMarksScreenProceedState();
}

class _AddMarksScreenProceedState extends State<AddMarksScreenProceed> {
  String? selectedClass = '6th B';
  String? selectedExam = 'Term 1';
  String? selectedSubject = 'English';
  String? selectedType = 'Theory';

  final List<Map<String, dynamic>> students = List.generate(
    9,
    (index) => {
      'sno': index + 1,
      'name': 'ABCD',
      'reading': TextEditingController(text: '17'),
      'writing': TextEditingController(text: '19'),
      'speaking': TextEditingController(text: '13'),
    },
  );

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
              // Handle menu button press
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
                _buildDropdownButton('Class', selectedClass, ['6th B'],
                    (value) {
                  setState(() {
                    selectedClass = value;
                  });
                }),
                _buildDropdownButton('Exam', selectedExam, ['Term 1'], (value) {
                  setState(() {
                    selectedExam = value;
                  });
                }),
                _buildDropdownButton('Subject', selectedSubject, ['English'],
                    (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                }),
                _buildDropdownButton('Type', selectedType, ['Theory'], (value) {
                  setState(() {
                    selectedType = value;
                  });
                }),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(label: Text('SNo')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Reading')),
                    DataColumn(label: Text('Writing')),
                    DataColumn(label: Text('Speaking')),
                  ],
                  rows: students.map((student) {
                    return DataRow(cells: [
                      DataCell(Text(student['sno'].toString())),
                      DataCell(Text(student['name'])),
                      DataCell(_buildMarksInputField(student['reading'])),
                      DataCell(_buildMarksInputField(student['writing'])),
                      DataCell(_buildMarksInputField(student['speaking'])),
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
              onPressed: () {
                // Handle save button press
              },
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

  Widget _buildDropdownButton(String label, String? selectedValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      underline: SizedBox(),
      icon: Icon(Icons.arrow_drop_down),
      style: TextStyle(fontSize: 16, color: Colors.black),
      dropdownColor: Colors.white,
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
          contentPadding: EdgeInsets.symmetric(
              vertical: 8, horizontal: 8), // Increased vertical padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
