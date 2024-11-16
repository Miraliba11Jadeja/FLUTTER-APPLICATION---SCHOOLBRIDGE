import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase 

class EditTeacherProfileScreen extends StatefulWidget {
  final String teacherId;
  final Map<String, dynamic> teacherData;

  EditTeacherProfileScreen({required this.teacherId, required this.teacherData});
  @override
  _EditTeacherProfileScreenState createState() => _EditTeacherProfileScreenState();
}
class _EditTeacherProfileScreenState extends State<EditTeacherProfileScreen> {
  bool isEditing = false;

  // Image-related variables
  File? _profileImage;
  String? _ProfilePicture;
  final ImagePicker _picker = ImagePicker();

  // Controllers to manage text field inputs
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController contactController;
  late TextEditingController genderController;
  late TextEditingController subjectController;  // Single controller for subjects

  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController pinCodeController;
  late TextEditingController countryController;
  late TextEditingController permanentAController;
  late TextEditingController PresentAController;
  late TextEditingController UsernameController;

  List<String> subjects = [];  // Store subjects as a list

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty values
    nameController = TextEditingController();
    emailController = TextEditingController();
    dobController = TextEditingController();
    contactController = TextEditingController();
    genderController = TextEditingController();
    subjectController = TextEditingController();
    permanentAController = TextEditingController();
    PresentAController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    pinCodeController = TextEditingController();
    countryController = TextEditingController();
    UsernameController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    contactController.dispose();
    genderController.dispose();
    subjectController.dispose();
    permanentAController.dispose();
    PresentAController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    countryController.dispose();
    UsernameController.dispose();

    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageToStorage(String teacherId) async {
    if (_profileImage == null) return;

    try {
      // Create a reference to the location in Firebase Storage
      String fileName = 'teacher_${teacherId}_profile_image.jpg';  // Fix: Use the teacherId value correctly
      Reference storageRef = FirebaseStorage.instance.ref().child('profileImages/$fileName');

      // Upload the image file
      UploadTask uploadTask = storageRef.putFile(_profileImage!);
      TaskSnapshot snapshot = await uploadTask;

      // Get the image URL after upload
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Update the Firestore database with the new image URL
      await FirebaseFirestore.instance.collection('Teacher').doc(teacherId).update({
        'ProfilePicture': imageUrl,
      });

      setState(() {
        _ProfilePicture = imageUrl;  // Update the local variable with the new image URL
      });

      // Notify the user of the successful upload
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile image updated successfully!')));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image')));
    }
  }

 Future<void> _updateTeacherProfile(String teacherId) async {
  if (nameController.text.isEmpty || emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all required fields')));
    return;
  }

  // Check if the profile image has changed, upload it to Firebase Storage
  if (_profileImage != null) {
    await _uploadImageToStorage(teacherId);  // Upload the new image
  }

  try {
    // Update the teacher profile data in Firestore
    await FirebaseFirestore.instance.collection('Teacher').doc(teacherId).update({
      'Name': nameController.text,
      'Email': emailController.text,
      'DOB': dobController.text,
      'Contact': contactController.text,
      'Gender': genderController.text,
      'Subjects': subjects,
      'PermanentA': permanentAController.text,
      'PresentA': PresentAController.text,
      'City': cityController.text,
      'State': stateController.text,
      'PinCode': pinCodeController.text,
      'Country': countryController.text,
      'Username': UsernameController.text,
      'lastEdited': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/back.png', // Make sure the path is correct
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text('Edit Teacher Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Teacher').doc(widget.teacherId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var teacherData = snapshot.data!;
          _ProfilePicture = teacherData['ProfilePicture'];
          subjects = List<String>.from(teacherData['Subjects'] ?? []);  // Get subjects as an array

          // Update text field controllers with Firestore data
          nameController.text = teacherData['Name'] ?? '';   
          emailController.text = teacherData['Email'] ?? ''; 
          dobController.text = teacherData['Dob'] ?? '';     
          contactController.text = teacherData['Contact'] ?? '';
          genderController.text = teacherData['Gender'] ?? '';
          PresentAController.text = teacherData['PresentA'] ?? '';
          permanentAController.text = teacherData['PermanentA'] ?? '';
          cityController.text = teacherData['City'] ?? '';
          stateController.text = teacherData['State'] ?? '';
          pinCodeController.text = teacherData['PinCode'] ?? '';
          countryController.text = teacherData['Country'] ?? '';
          UsernameController.text = teacherData['Username']?? '';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Profile Picture Section
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null 
                        ? FileImage(_profileImage!) 
                        : (_ProfilePicture != null && _ProfilePicture!.isNotEmpty) 
                            ? NetworkImage(_ProfilePicture!) as ImageProvider
                            : null,
                    child: _profileImage == null && (_ProfilePicture == null || _ProfilePicture!.isEmpty)
                        ? Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showImageSourceActionSheet(context, widget.teacherId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF134B70),
                      side: BorderSide(color: Color(0xFF134B70)),
                    ),
                    child: Text(
                      'Change Profile Picture',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Personal Details Section
                  buildSectionTitle('PERSONAL DETAILS'),
                  buildDetailsRow('Name', nameController, 'Email', emailController),
                  buildDetailsRow('Date Of Birth', dobController, 'Contact No', contactController),
                  buildDetailsRow('Gender', genderController, 'Gender', genderController),
                  SizedBox(height: 20),

                  // Subjects Section (Read-only)
                  buildSectionTitle('Academic'),
                  Row(
                    children: [
                      Text('Subjects: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      ...subjects.map((subject) => Padding(
                        padding: const EdgeInsets.only(right: 8.0), // Add some space between subjects
                        child: Text(subject),
                      )).toList(),
                    ],
                  ),
                  SizedBox(height: 20),


                  // Contact Details Section
                  buildSectionTitle('CONTACT DETAILS'),
                  buildDetailsRow('Present Address', PresentAController, 'Permanent Address', permanentAController),
                  buildDetailsRow('State', stateController, 'PinCode', pinCodeController),
                  buildDetailsRow('Country', countryController, 'City', cityController),
                  SizedBox(height: 40),

                  // Username and Password Section
                  buildSectionTitle('Credentials'),
                  buildDetailsRow('Username', UsernameController, 'Password', nameController), // Placeholder example

                  // Update Button
                  ElevatedButton(
                    onPressed: () {
                      _updateTeacherProfile(widget.teacherId);
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method to build title for each section
  Widget buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 30),
  decoration: BoxDecoration(
    color: Color(0xFF134B70), // Background color for the title
    borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners if you like
  ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(title, style: TextStyle(color: Colors.white,backgroundColor:Color(0xFF134B70)  , fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Helper method to build a row of text fields
  Widget buildDetailsRow(String leftLabel, TextEditingController leftController, String rightLabel, TextEditingController rightController) {
    return Row(
      children: [
        Expanded(child: buildTextField(leftLabel, leftController)),
        SizedBox(width: 10),
        Expanded(child: buildTextField(rightLabel, rightController)),
      ],
    );
  }

  // Helper method to build a text field with no border
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
      ),
    );
  }

  // Helper method to display image picker options
  void _showImageSourceActionSheet(BuildContext context, String teacherId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }
}
