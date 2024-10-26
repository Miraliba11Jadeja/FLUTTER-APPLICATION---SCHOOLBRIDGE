import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HolidayTeacherScreen extends StatefulWidget {
  @override
  _HolidayTeacherScreenState createState() => _HolidayTeacherScreenState();
}

class _HolidayTeacherScreenState extends State<HolidayTeacherScreen> {
  List<Map<String, dynamic>> holidays = [];
  final TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  String formattedDate = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchHolidays();
  }

 void fetchHolidays() async {
  try {
    FirebaseFirestore.instance.collection('Holiday').snapshots().listen((snapshot) {
      final data = snapshot.docs.map((doc) {
        // Ensure both fields are extracted safely
        String? name = doc.data().containsKey('Name') ? doc['Name'] : null;
        String? date = doc.data().containsKey('Date') ? doc['Date'] : null;

        // Only add documents with valid data
        if (name != null && date != null) {
          return {'id': doc.id, 'name': name, 'date': date};
        }
        return null;
      }).where((doc) => doc != null).toList();

      setState(() {
        holidays = data.cast<Map<String, dynamic>>();
      });

      if (holidays.isEmpty) {
        print('No holidays found in Firestore.');
      }
    });
  } catch (e) {
    print('Error fetching holidays: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching holiday data')),
    );
  }
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _addHolidayToFirestore,
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addHolidayToFirestore() async {
    if (nameController.text.isNotEmpty && formattedDate.isNotEmpty) {
      final newHoliday = {
        'Name': nameController.text,
        'Date': formattedDate,
      };
      await FirebaseFirestore.instance.collection('Holiday').add(newHoliday);
      nameController.clear();
      formattedDate = '';
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
    }
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
                Navigator.of(context).pop();
              },
              child: Text('Keep'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('Holiday')
                    .doc(holidays[index]['id'])
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF134B70),
                  ),
                  child: Center(
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              buildDrawerItem(context, 'assets/SUB.png', 'Profile'),
              buildDrawerItem(context, 'assets/attendance.png', 'Attendance'),
              buildDrawerItem(context, 'assets/timetable.png', 'Schedule'),
              buildDrawerItem(context, 'assets/chat.png', 'Feedback'),
              buildDrawerItem(context, 'assets/calendar.png', 'Event'),
              buildDrawerItem(context, 'assets/loudspeaker.png', 'Announcement'),
              buildDrawerItem(context, 'assets/holidays.png', 'Holiday'),
              buildDrawerItem(context, 'assets/score.png', 'Marks'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: holidays.isEmpty
            ? Center(child: Text("No holidays found"))
            : ListView.builder(
                itemCount: holidays.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showDeleteDialog(index);
                    },
                    child: HolidayCard(
                      holidayName: holidays[index]['name'],
                      holidayDate: holidays[index]['date'],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHolidayDialog,
        backgroundColor: Color(0xFF134B70),
        child: Icon(Icons.add, size: 40),
      ),
    );
  }

  ListTile buildDrawerItem(BuildContext context, String asset, String title) {
    return ListTile(
      leading: Image.asset(asset, width: 30, height: 30),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.of(context).pop();
      },
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
          color: Colors.blue,
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
