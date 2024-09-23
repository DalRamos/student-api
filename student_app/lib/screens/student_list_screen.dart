import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/student.dart';
import 'add_student_screen.dart';
import '../widgets/student_card.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/students'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          students = jsonList.map((json) => Student.fromJson(json)).toList();
        });
      } else {
        // Handle error response
        throw Exception('Failed to load students');
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching students: $e');
    }
  }

  Future<void> _addStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/students'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(student.toJson()),
      );

      if (response.statusCode == 201) {
        _fetchStudents(); // Refresh the list
      } else {
        throw Exception('Failed to add student');
      }
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  Future<void> _editStudent(int index, Student updatedStudent) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/students/$index'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedStudent.toJson()),
      );

      if (response.statusCode == 200) {
        _fetchStudents(); // Refresh the list
      } else {
        throw Exception('Failed to update student');
      }
    } catch (e) {
      print('Error editing student: $e');
    }
  }

  Future<void> _deleteStudent(int index) async {
    try {
      final response = await http
          .delete(Uri.parse('http://localhost:3000/api/students/$index'));

      if (response.statusCode == 200) {
        _fetchStudents(); // Refresh the list
      } else {
        throw Exception('Failed to delete student');
      }
    } catch (e) {
      print('Error deleting student: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Lists'),
        centerTitle: true,
      ),
      body: students.isEmpty
          ? Center(child: Text('No students added yet.'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return StudentCard(
                  student: students[index],
                  onEdit: () async {
                    final updatedStudent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddStudentScreen()),
                    );

                    if (updatedStudent != null) {
                      _editStudent(index, updatedStudent);
                    }
                  },
                  onDelete: () => _deleteStudent(index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newStudent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );

          if (newStudent != null) {
            _addStudent(newStudent);
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add Student',
      ),
    );
  }
}
