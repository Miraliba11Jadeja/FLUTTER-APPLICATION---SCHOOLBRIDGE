import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFeedbackForm extends StatefulWidget {
  @override
  _AddFeedbackFormState createState() => _AddFeedbackFormState();
}

class _AddFeedbackFormState extends State<AddFeedbackForm> {
  String? selectedClass;
  String? selectedTeacher;
  List<Map<String, dynamic>> questions = [];

  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addQuestion() {
    setState(() {
      questions.add({
        'questionText': '',
        'options': List<String>.filled(5, ''), // Ensure options are initialized correctly
      });
    });
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate() && selectedClass != null && selectedTeacher != null) {
      _formKey.currentState!.save();

      try {
        // Add feedback to the Firestore collection
        await _firestore.collection('Feedback').add({
          'class': selectedClass,
          'teacher': selectedTeacher,
          'questions': questions,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );

        // Reset the form
        setState(() {
          selectedClass = null;
          selectedTeacher = null;
          questions.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feedback: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Class Dropdown
              // Class Dropdown
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Class').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading classes');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No classes found');
                  }

                  // Ensure items are of type DropdownMenuItem<String>
                  List<DropdownMenuItem<String>> classItems = snapshot.data!.docs.map((doc) {
                    // Cast 'Name' as String
                    final className = doc['Class'] as String;
                    return DropdownMenuItem<String>(
                      value: className,
                      child: Text(className),
                    );
                  }).toList();

                  return DropdownButtonFormField<String>(
                    value: selectedClass,
                    items: classItems,
                    onChanged: (value) {
                      setState(() {
                        selectedClass = value;
                      });
                    },
                    hint: Text('Select Class'),
                    validator: (value) => value == null ? 'Please select a class' : null,
                  );
                },
              ),


              SizedBox(height: 16),

              // Teacher Dropdown
              // Teacher Dropdown
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Teacher').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading teachers');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No teachers found');
                  }

                  // Ensure items are of type DropdownMenuItem<String>
                  List<DropdownMenuItem<String>> teacherItems = snapshot.data!.docs.map((doc) {
                    // Cast 'Name' as String
                    final teacherName = doc['Name'] as String;
                    return DropdownMenuItem<String>(
                      value: teacherName,
                      child: Text(teacherName),
                    );
                  }).toList();

                  return DropdownButtonFormField<String>(
                    value: selectedTeacher,
                    items: teacherItems,
                    onChanged: (value) {
                      setState(() {
                        selectedTeacher = value;
                      });
                    },
                    hint: Text('Select Teacher'),
                    validator: (value) => value == null ? 'Please select a teacher' : null,
                  );
                },
              ),

              SizedBox(height: 16),

              // Questions
              ...questions.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> question = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Question ${index + 1}'),
                      onChanged: (value) {
                        question['questionText'] = value;
                      },
                      validator: (value) => value!.isEmpty ? 'Please enter a question' : null,
                    ),
                    Column(
                      children: List.generate(5, (optionIndex) {
                        return TextFormField(
                          decoration: InputDecoration(labelText: 'Option ${optionIndex + 1}'),
                          onChanged: (value) {
                            question['options'][optionIndex] = value;
                          },
                          validator: (value) => value!.isEmpty ? 'Please enter an option' : null,
                        );
                      }),
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),

              // Add Question Button
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text('Add Question'),
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitFeedback,
                child: Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
