import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class EditMarksScreen extends StatefulWidget {
  final String selectedClass;
  final String selectedSubject;

  EditMarksScreen({required this.selectedClass, required this.selectedSubject});

  @override
  _EditMarksScreenState createState() => _EditMarksScreenState();
}

class _EditMarksScreenState extends State<EditMarksScreen> {
  List<Map<String, dynamic>> distributions = [];
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> marksControllers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDistributions();
  }

  // Fetch distributions from Firestore
  Future<void> _fetchDistributions() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('markslist')
          .where('class', isEqualTo: widget.selectedClass)
          .where('subject', isEqualTo: widget.selectedSubject)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data() as Map<String, dynamic>;

        if (data.containsKey('distributions')) {
          setState(() {
            distributions = List<Map<String, dynamic>>.from(data['distributions']);

            // Initialize controllers with fetched data
            nameControllers = distributions
                .map((dist) => TextEditingController(text: dist['distribution_name']))
                .toList();
            marksControllers = distributions
                .map((dist) => TextEditingController(text: dist['total_marks'].toString()))
                .toList();
          });
        }
      } else {
        print('No matching document found for the selected class and subject.');
      }
    } catch (e) {
      print('Error fetching distributions: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save updated distributions back to Firestore
  Future<void> _saveDistributions() async {
    try {
      // Update local list with edited data
      for (int i = 0; i < distributions.length; i++) {
        distributions[i]['distribution_name'] = nameControllers[i].text;
        distributions[i]['total_marks'] = int.tryParse(marksControllers[i].text) ?? 0;
      }

      // Update Firestore document
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('markslist')
          .where('class', isEqualTo: widget.selectedClass)
          .where('subject', isEqualTo: widget.selectedSubject)
          .get();

      if (query.docs.isNotEmpty) {
        String docId = query.docs.first.id;

        await FirebaseFirestore.instance
            .collection('markslist')
            .doc(docId)
            .update({'distributions': distributions});

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Distributions updated successfully!'),
          backgroundColor: Colors.green,
        ));
      } else {
        print('No document found to update.');
      }
    } catch (e) {
      print('Error saving distributions: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save distributions. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Add a new distribution
  void _addDistribution() {
    setState(() {
      distributions.add({"distribution_name": "", "total_marks": 0});
      nameControllers.add(TextEditingController());
      marksControllers.add(TextEditingController());
    });
  }

  // Build the UI for each distribution
  Widget _buildDistributionFields() {
    return Column(
      children: distributions.asMap().entries.map((entry) {
        int index = entry.key;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name of Distribution ${index + 1}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameControllers[index],
              decoration: InputDecoration(
                hintText: "Enter name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Total Marks of ${index + 1}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: marksControllers[index],
              decoration: InputDecoration(
                hintText: "Enter marks",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF134B70),
        title: Text('EDIT MARKS'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(7.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDistributionFields(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _addDistribution,
                          child: Text('ADD DISTRIBUTION'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF134B70),
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 17),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _saveDistributions,
                          child: Text('SAVE DISTRIBUTIONS'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF134B70),
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 17),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
