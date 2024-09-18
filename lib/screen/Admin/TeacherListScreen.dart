import 'package:flutter/material.dart';

class TeacherListScreen extends StatelessWidget {
  final List<Map<String, String>> teachers = [
    {"name": "ABCD", "subject": "Hindi", "classes": "2, 3, 4"},
    {"name": "EFGH", "subject": "Math", "classes": "5, 6, 7"},
    {"name": "IJKL", "subject": "English", "classes": "8, 9, 10"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('TEACHERS'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Go back when back icon is pressed
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/back.png', // Ensure this image is added in your project under the assets folder
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
                  Scaffold.of(context).openEndDrawer(); // Open end drawer when menu icon is pressed
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      Container(
        height: 100, // Adjust the height as needed
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
      ListTile(
        leading: Image.asset('assets/teacher.png', width: 30, height: 30),
        title: Text('Teachers', style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.of(context).pop(); // Close drawer on tap
        },
      ),
      ListTile(
        leading: Image.asset('assets/add.png', width: 30, height: 30),
        title: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: Image.asset('assets/timetable.png', width: 30, height: 30),
        title: Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: Image.asset('assets/chat.png', width: 30, height: 30),
        title: Text('Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: Image.asset('assets/calendar.png', width: 30, height: 30),
        title: Text('Event', style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: Image.asset('assets/loudspeaker.png', width: 30, height: 30),
        title: Text('Announcement', style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      ListTile(
        leading: Image.asset('assets/holidays.png', width: 30, height: 30),
        title: Text('Holiday', style: TextStyle(fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  ),
),

      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Colors.blue.shade200,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NAME: ${teacher['name']}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "SUBJECT NAME: ${teacher['subject']}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "CLASS: ${teacher['classes']}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Handle edit action
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Handle delete action
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add teacher action
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF134B70),
      ),
    );
  }
}
