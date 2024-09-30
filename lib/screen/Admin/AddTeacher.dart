import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For handling file operations

class AddTeacher extends StatefulWidget {
  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  File? _profileImage; // To store the selected image

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('TEACHER PROFILE'),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Go back when back icon is pressed
          },
          child: Icon(Icons.arrow_back),
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
              buildDrawerItem(context, 'assets/teacher.png', 'Teachers'),
              buildDrawerItem(context, 'assets/add.png', 'Subject'),
              buildDrawerItem(context, 'assets/timetable.png', 'Schedule'),
              buildDrawerItem(context, 'assets/chat.png', 'Feedback'),
              buildDrawerItem(context, 'assets/calendar.png', 'Event'),
              buildDrawerItem(context, 'assets/loudspeaker.png', 'Announcement'),
              buildDrawerItem(context, 'assets/holidays.png', 'Holiday'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null ? Icon(Icons.person, size: 50) : null,
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickImage, // Call the image picker function
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text(
                  'ADD PROFILE PICTURE',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF134B70),
                  elevation: 0,
                ),
              ),
              SizedBox(height: 20),
              buildSectionTitle('PERSONAL DETAILS'),
              buildDetailRow('Name', 'ABCD'),
              buildDetailRow('Contact No', '1234567890'),
              buildDetailRow('Email', 'abc@def.com'),
              buildDetailRow('Gender', 'Male/Female'),
              buildDetailRow('Date Of Birth', 'DD/MM/YYYY'),
              buildDetailRow('Aadhar No', 'ABCDABCD3828'),
              SizedBox(height: 20),
              buildSectionTitle('CONTACT DETAILS'),
              buildDetailRow('Permanent Address', 'ABCD, House Name, Landmark'),
              buildDetailRow('Present Address', 'ABCD, House Name, Landmark'),
              buildDetailRow('City', 'Rajkot'),
              buildDetailRow('PinCode', '360020'),
              buildDetailRow('State', 'Gujarat'),
              buildDetailRow('Country', 'India'),
              SizedBox(height: 20),
              buildSectionTitle('ACADEMIC DETAILS'),
              buildDetailRow('Class', '2, 3, 4'),
              buildDetailRow('Subject', 'Hindi'),
              buildDetailRow('Education', 'BTech'),
              buildDetailRow('Specification', 'Hindi'),
              SizedBox(height: 20),
              buildSectionTitle('ACCOUNT DETAILS'),
              buildDetailRow('Username', 'abc11'),
              buildDetailRow('Password', 'abc@1234'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Saved successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text('SUBMIT'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF134B70),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
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

  Widget buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.0),
      color: Color(0xFF134B70),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String hintText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    ),
  );
}

}
