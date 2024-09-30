import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the selected date

void main() {
  runApp(HolidayApp());
}

class HolidayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HolidayTeacherScreen(),
    );
  }
}

class HolidayTeacherScreen extends StatefulWidget {
  @override
  _HolidayTeacherScreenState createState() => _HolidayTeacherScreenState();
}

class _HolidayTeacherScreenState extends State<HolidayTeacherScreen> {
  List<Map<String, String>> holidays = [
    {'name': 'MAKAR SANKRANTI', 'date': '14 Jan, 2024'},
    {'name': 'REPUBLIC DAY', 'date': '26 Jan, 2024'},
    {'name': 'RAMZAN-ID', 'date': '10 Apr, 2024'},
  ];

  TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  String formattedDate = '';

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Holiday'),
          content: Text('Do you want to delete this holiday?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog and keep the holiday
              },
              child: Text('Keep'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  holidays.removeAt(index); // Delete the holiday from the list
                });
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddHolidayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ADD HOLIDAY'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: formattedDate.isEmpty
                          ? 'Select Date'
                          : formattedDate,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without adding
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && formattedDate.isNotEmpty) {
                  setState(() {
                    holidays.add({
                      'name': nameController.text,
                      'date': formattedDate,
                    });
                  });
                  nameController.clear();
                  formattedDate = '';
                  Navigator.of(context).pop(); // Close the dialog after adding
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        formattedDate = DateFormat('dd MMM, yyyy').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('HOLIDAY'),
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
              // Handle menu press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: holidays.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _showDeleteDialog(index); // Show dialog when tapped
              },
              child: HolidayCard(
                holidayName: holidays[index]['name']!,
                holidayDate: holidays[index]['date']!,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHolidayDialog, // Show the add holiday dialog
        backgroundColor: Color(0xFF134B70),
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}

class HolidayCard extends StatelessWidget {
  final String holidayName;
  final String holidayDate;

  HolidayCard({
    required this.holidayName,
    required this.holidayDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue, // Border color
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.radio_button_checked, color: Colors.blue, size: 30),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holidayName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  holidayDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
