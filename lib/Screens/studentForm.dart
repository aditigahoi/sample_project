import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User _currentUser;
  final TextEditingController _dateController = TextEditingController();

  // Define variables to store form data
  String _name = '';
  String _gender = '';
  DateTime _dob = DateTime.now();

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _dob = selectedDate;
        _dateController.text = _dob.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 136, 87, 221),
        title: const Text('Add Student Details'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Student Name',
                  filled: true,
                  fillColor: Color.fromARGB(255, 232, 146, 240),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student\'s name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                onTap: _selectDate,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today),
                  labelText: 'Date of Birth',
                  filled: true,
                  fillColor: Color.fromARGB(255, 232, 146, 240),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  labelText: 'Gender',
                  filled: true,
                  fillColor: Color.fromARGB(255, 232, 146, 240),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: _gender.isEmpty ? null : _gender,
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary:
                      Color.fromARGB(255, 136, 87, 221), // Background color
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                ),
                onPressed: _saveFormDataToFirestore,
                child: const Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveFormDataToFirestore() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Reference to the teacher's sub-collection
        final CollectionReference students = FirebaseFirestore.instance
            .collection('teachers')
            .doc(_currentUser.uid)
            .collection('students');

        await students.add({
          'userId': _currentUser.uid,
          'email': _currentUser.email,
          'name': _name,
          'dob': _dob,
          'gender': _gender,
        });
        print("Student Added");

        // Clear the form fields
        _formKey.currentState!.reset();
        _dateController.clear();
        setState(() {
          _gender = '';
        });

        // Show a Snackbar to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student details added successfully')),
        );
      } catch (error) {
        print("Failed to add student: $error");
      }
    }
  }
}
