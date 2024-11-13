import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool isEditing = false;

  // Initial profile data
  String name = 'Student Name';
  String email = 'student@example.com';
  String dob = '01/01/2000';
  String contactNo = '9876543210';
  String gender = 'Male';
  String aadharNo = '1234 5678 9012';

  String permanentAddress = 'Street Address, City';
  String city = 'City Name';
  String state = 'State Name';
  String pinCode = '123456';
  String presentAddress = 'Current Address, City';
  String country = 'Country Name';

  // Image-related variables
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Controllers to manage text field inputs
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController contactController;
  late TextEditingController genderController;
  late TextEditingController aadharController;

  late TextEditingController permanentAddressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController pinCodeController;
  late TextEditingController presentAddressController;
  late TextEditingController countryController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current data
    nameController = TextEditingController(text: name);
    emailController = TextEditingController(text: email);
    dobController = TextEditingController(text: dob);
    contactController = TextEditingController(text: contactNo);
    genderController = TextEditingController(text: gender);
    aadharController = TextEditingController(text: aadharNo);

    permanentAddressController = TextEditingController(text: permanentAddress);
    cityController = TextEditingController(text: city);
    stateController = TextEditingController(text: state);
    pinCodeController = TextEditingController(text: pinCode);
    presentAddressController = TextEditingController(text: presentAddress);
    countryController = TextEditingController(text: country);
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    contactController.dispose();
    genderController.dispose();
    aadharController.dispose();

    permanentAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    presentAddressController.dispose();
    countryController.dispose();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF134B70),
        title: const Text('Student Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Picture Section
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showImageSourceActionSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                ),
                child: const Text(
                  'Change Profile Picture',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),

              // Personal Details Section
              buildSectionTitle('PERSONAL DETAILS'),
              buildDetailsRow('Name', nameController, 'Email', emailController),
              buildDetailsRow('Date Of Birth', dobController, 'Contact No', contactController),
              buildDetailsRow('Gender', genderController, 'Aadhar No.', aadharController),

              const SizedBox(height: 20),

              // Contact Details Section
              buildSectionTitle('CONTACT DETAILS'),
              buildDetailsRow('Permanent Address', permanentAddressController, 'City', cityController),
              buildDetailsRow('State', stateController, 'PinCode', pinCodeController),
              buildDetailsRow('Present Address', presentAddressController, 'Country', countryController),

              const SizedBox(height: 40),

              // Edit/Save Button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isEditing) {
                      // Save the updated data
                      name = nameController.text;
                      email = emailController.text;
                      dob = dobController.text;
                      contactNo = contactController.text;
                      gender = genderController.text;
                      aadharNo = aadharController.text;

                      permanentAddress = permanentAddressController.text;
                      city = cityController.text;
                      state = stateController.text;
                      pinCode = pinCodeController.text;
                      presentAddress = presentAddressController.text;
                      country = countryController.text;
                    }
                    isEditing = !isEditing; // Toggle the editing state
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF134B70), // Corrected backgroundColor usage
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isEditing ? 'Save' : 'Edit Profile',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper widget to build section titles
  Widget buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF134B70),
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  // Helper widget to build details rows
  Widget buildDetailsRow(String label1, TextEditingController controller1, String label2, TextEditingController controller2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label1, style: const TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: controller1,
                  readOnly: !isEditing,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label2, style: const TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: controller2,
                  readOnly: !isEditing,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}// TODO Implement this library.