import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';

class Student {
  final String id;
  final String name;
  final String gender;
  final DateTime dob;
  final String email;

  Student({
    required this.id,
    required this.name,
    required this.gender,
    required this.dob,
    required this.email,
  });

  factory Student.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'] ?? '',
      gender: data['gender'] ?? '',
      dob: (data['dob'] as Timestamp).toDate(),
      email: data['email'] ?? '',
    );
  }
}

class StudentListScreen extends StatefulWidget {
  final String teacherId;

  StudentListScreen({required this.teacherId});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late CollectionReference studentsCollection;

  @override
  void initState() {
    super.initState();
    studentsCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(widget.teacherId)
        .collection('students');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: studentsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No students found.'));
          }

          List<Student> students = snapshot.data!.docs
              .map((doc) => Student.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              Student student = students[index];
              return Padding(
                padding: EdgeInsets.all(12.0), // Padding around the Card
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4,
                  shadowColor: Colors.grey[300],
                  child: Padding(
                    padding: EdgeInsets.all(12.0), // Padding inside the Card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Date of Birth: ${student.dob.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          'Gender: ${student.gender}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 2.0),
                      ],
                    ),
                  ),
                ),
              );
              // return ListTile(
              //   title: Text(student.name),
              //   subtitle: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //           'DOB: ${student.dob.toLocal().toString().split(' ')[0]}'),
              //       Text('Gender: ${student.gender}'),
              //       Text('Email: ${student.email}'),
              //     ],
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
