import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  // Text controllers for form inputs
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController permanentAController = TextEditingController();
  TextEditingController presentAController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController previousResultController = TextEditingController();

  // Image selection
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance; // Firebase Storage instance

  // Variables to hold fetched class data
  List<String> classes = [];
  String? selectedClass; // Holds the selected class

  // Fetch classes from Firestore
  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Class').get();
      setState(() {
        classes = snapshot.docs.map((doc) => doc['Class'] as String).toList();
      });
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Function to handle form submission and Firebase authentication
  Future<void> _submitForm() async {
    try {
      // Step 1: Create the user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user == null) {
        throw Exception('User creation failed. User is null.');
      }

      // Step 2: Upload the image if it is selected
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage();
      }

      // Step 3: Store student details in Firestore, including the password
      await _firestore.collection('Student').doc(user.uid).set({
        'Name': nameController.text.trim(),
        'Contact': contactController.text.trim(),
        'Email': emailController.text.trim(),
        'Gender': genderController.text.trim(),
        'Dob': dobController.text.trim(),
        'Aadhar': aadharController.text.trim(),
        'PresentA': presentAController.text.trim(),
        'PermanentA': permanentAController.text.trim(),
        'City': cityController.text.trim(),
        'State': stateController.text.trim(),
        'PinCode': pinCodeController.text.trim(),
        'Country': countryController.text.trim(),
        'Class': selectedClass,
        'Username': usernameController.text.trim(),
        'Password': passwordController.text.trim(), // Save password to Firestore
        'Previous Result': previousResultController.text.trim(),
        'ProfilePicture': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Student added successfully!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding student: $e'),
      ));
    }
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return null;
    try {
      String fileName = 'profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('STUDENT PROFILE'),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ],
      ),
      endDrawer: buildDrawer(context),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null ? Icon(Icons.person, size: 50) : null,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text('ADD PROFILE PICTURE', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF134B70)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              buildSectionTitle('PERSONAL DETAILS'),
              buildDetailRow('Name', nameController),
              buildDetailRow('Contact No', contactController),
              buildDetailRow('Email', emailController),
              buildDetailRow('Gender', genderController),
              buildDetailRow('Date Of Birth', dobController),
              buildDetailRow('Aadhar No', aadharController),
              SizedBox(height: 20),
              buildSectionTitle('CONTACT DETAILS'),
              buildDetailRow('PresentA', presentAController),
              buildDetailRow('PermanentA', permanentAController),
              buildDetailRow('City', cityController),
              buildDetailRow('State', stateController),
              buildDetailRow('PinCode', pinCodeController),
              buildDetailRow('Country', countryController),
              SizedBox(height: 20),
              buildSectionTitle('ACADEMIC DETAILS'),
              buildClassDropdown('Class', classes),
              buildDetailRow('Previous Result', previousResultController),
              SizedBox(height: 20),
              buildSectionTitle('ACCOUNT DETAILS'),
              buildDetailRow('Username', usernameController),
              buildDetailRow('Password', passwordController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('SUBMIT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF134B70),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          buildDrawerHeader(),
          buildDrawerItem(context, 'assets/teacher.png', 'Teachers', onTap: () {}),
          buildDrawerItem(context, 'assets/add.png', 'Subject', onTap: () {}),
          buildDrawerItem(context, 'assets/timetable.png', 'Schedule', onTap: () {}),
          buildDrawerItem(context, 'assets/chat.png', 'Feedback', onTap: () {}),
          buildDrawerItem(context, 'assets/report.png', 'Student Report', onTap: () {}),
          buildDrawerItem(context, 'assets/logout.png', 'Log out', onTap: () {}),
        ],
      ),
    );
  }

  Widget buildDrawerHeader() {
    return Container(
      height: 200,
      child: DrawerHeader(
        decoration: BoxDecoration(color: Color(0xFF134B70)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Admin',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, String iconPath, String label, {Function()? onTap}) {
    return ListTile(
      leading: Image.asset(iconPath, height: 24, width: 24),
      title: Text(label, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF134B70),
      ),
    );
  }

  Widget buildDetailRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildClassDropdown(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedClass, // This can be null initially
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedClass = value; // Update the selected class
          });
        },
        hint: Text('Select a class'), // Hint when no value is selected
      ),
    );
  }
}
