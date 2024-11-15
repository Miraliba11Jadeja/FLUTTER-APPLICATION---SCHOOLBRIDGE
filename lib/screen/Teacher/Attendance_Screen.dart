import 'package:flutter/material.dart';

void main() {
  runApp(AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String selectedFilter = 'All';

  // List of attendance items
  final List<Map<String, dynamic>> attendanceItems = [
    {
      'className': '2C',
      'date': '12 Sep 2024',
      'subject': 'Sanskrit',
      'status': 'Completed',
      'statusColor': Colors.green,
    },
    {
      'className': '8C',
      'date': '23 Oct 2024',
      'subject': 'Sanskrit',
      'status': 'Pending',
      'statusColor': Colors.orange,
    },
    {
      'className': '8C',
      'date': '23 Oct 2024',
      'subject': 'Sanskrit',
      'status': 'Pending',
      'statusColor': Colors.orange,
    },
    {
      'className': '8C',
      'date': '23 Oct 2024',
      'subject': 'Sanskrit',
      'status': 'Pending',
      'statusColor': Colors.orange,
    },
  ];

  // Function to filter attendance items based on the selected status
  List<Map<String, dynamic>> getFilteredItems() {
    if (selectedFilter == 'All') {
      return attendanceItems;
    } else {
      return attendanceItems
          .where((item) => item['status'] == selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text("ATTENDANCE"),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/back.png', // Ensure the correct path to your back icon image
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Open endDrawer on menu icon click
                },
              );
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
      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterButton(
                  label: 'All',
                  color: selectedFilter == 'All' ? Colors.blue : Colors.blue[100]!,
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'All';
                    });
                  },
                ),
                FilterButton(
                  label: 'Pending',
                  color: selectedFilter == 'Pending' ? Colors.orange : Colors.orange[100]!,
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'Pending';
                    });
                  },
                ),
                FilterButton(
                  label: 'Completed',
                  color: selectedFilter == 'Completed' ? Colors.green : Colors.green[100]!,
                  onPressed: () {
                    setState(() {
                      selectedFilter = 'Completed';
                    });
                  },
                ),
              ],
            ),
          ),
          // Attendance List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: getFilteredItems().map((item) {
                return AttendanceCard(
                  className: item['className'],
                  date: item['date'],
                  subject: item['subject'],
                  status: item['status'],
                  statusColor: item['statusColor'],
                  onTap: () {
                    if (item['status'] == 'Pending') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedAttendancePage(
                            className: item['className'],
                            date: item['date'],
                            subject: item['subject'],
                          ),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
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

class FilterButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  FilterButton({required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final String className;
  final String date;
  final String subject;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap; // Nullable onTap function

  AttendanceCard({
    required this.className,
    required this.date,
    required this.subject,
    required this.status,
    required this.statusColor,
    this.onTap, // Nullable onTap function
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (status == 'Pending') {
          // Directly navigate to detailed attendance for pending status
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailedAttendancePage(
                className: className,
                date: date,
                subject: subject,
              ),
            ),
          );
        } else if (status == 'Completed') {
          // Show dialog to confirm if user wants to edit attendance
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Edit Attendance'),
                content: Text('Do you want to edit the attendance for this class?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      // Navigate to detailed attendance if the user selects "Yes"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedAttendancePage(
                            className: className,
                            date: date,
                            subject: subject,
                          ),
                        ),
                      );
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: statusColor,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Class: $className',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Date: $date'),
                    SizedBox(height: 8),
                    Text(subject),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// New screen to display detailed attendance
class DetailedAttendancePage extends StatefulWidget {
  final String className;
  final String date;
  final String subject;

  DetailedAttendancePage({
    required this.className,
    required this.date,
    required this.subject,
  });

  @override
  _DetailedAttendancePageState createState() => _DetailedAttendancePageState();
}

class _DetailedAttendancePageState extends State<DetailedAttendancePage> {
  // Mock student data with names, roll numbers, and attendance status
  final List<Map<String, dynamic>> students = [
    {'name': 'ABCD', 'rollNo': 1, 'status': true}, // true for Present
    {'name': 'ABCD', 'rollNo': 2, 'status': true},
    {'name': 'ABCD', 'rollNo': 3, 'status': false}, // false for Absent
    {'name': 'ABCD', 'rollNo': 4, 'status': true},
    {'name': 'ABCD', 'rollNo': 5, 'status': false},
    {'name': 'ABCD', 'rollNo': 6, 'status': true},
    {'name': 'ABCD', 'rollNo': 7, 'status': true},
    {'name': 'ABCD', 'rollNo': 8, 'status': false},
    {'name': 'ABCD', 'rollNo': 9, 'status': false},
    {'name': 'ABCD', 'rollNo': 10, 'status': true},
    {'name': 'ABCD', 'rollNo': 11, 'status': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text("ATTENDANCE"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Column(
        children: [
          // Class, Date, and Subject Information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Class: ${widget.className}', style: TextStyle(fontSize: 16)),
                    Text('Date: ${widget.date}', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Text(widget.subject, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          // Table headers: Name, Roll No, Status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Roll No', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Divider(thickness: 2),
          // List of students with attendance status using Toggle Switch
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Display name
                      Expanded(flex: 2, child: Text(students[index]['name'], style: TextStyle(fontSize: 16))),
                      // Display roll number (Reduced space for roll number by setting flex to 1)
                      Expanded(flex: 2, child: Text(students[index]['rollNo'].toString(), style: TextStyle(fontSize: 16))),
                      // Toggle Switch for Present/Absent (More space for the status with flex 3)
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              students[index]['status'] ? 'Present' : 'Absent',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: students[index]['status'] ? Colors.blue : Colors.orange,
                              ),
                            ),
                            Switch(
                              value: students[index]['status'],
                              onChanged: (bool newValue) {
                                setState(() {
                                  students[index]['status'] = newValue;
                                });
                              },
                              activeColor: Colors.blue, // Color for "Present"
                              inactiveThumbColor: Colors.orange, // Color for "Absent"
                              inactiveTrackColor: Colors.orange[200],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Confirm & Submit Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle submit logic
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF134B70),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Confirm & Submit Attendance'),
            ),
          ),
        ],
      ),
    );
  }
}