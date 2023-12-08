import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_managemnt_app/screens/profile.dart';

import '../functions/functions.dart';
import 'model.dart';


class infoscreen extends StatefulWidget {
  const infoscreen({Key? key}) : super(key: key);

  @override
  State<infoscreen> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<infoscreen> {
  late List<Map<String, dynamic>> _studentsData = [];
    TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    List<Map<String, dynamic>> students = await getAllStudents();
    if (searchController.text.isNotEmpty) {
    students = students.where((student) =>
        student['name']
            .toString()
            .toLowerCase()
            .contains(searchController.text.toLowerCase())).toList(); 
  }

    
    setState(() {
      _studentsData = students;
    });
  }

  Future<void> _showEditDialog(int index) async {
    final student = _studentsData[index];
    final TextEditingController nameController =
        TextEditingController(text: student['name']);
    final TextEditingController regnoController =
        TextEditingController(text: student['regno'].toString());
    final TextEditingController departmentController =
        TextEditingController(text: student['department']);
    final TextEditingController emailController =
        TextEditingController(text: student['email']);
        final TextEditingController phoneController =TextEditingController (text: student['phone']);


    showDialog(
      context: context,
      builder: (BuildContext) => AlertDialog(
        title: Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: regnoController,
                decoration: InputDecoration(labelText: "Reg no"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email ID"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await updateStudent(
                StudentModel(
                  id: student['id'], 
                  rollno: regnoController.text,
                  name: nameController.text,
                  department: departmentController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  imageurl: student['imageurl'],
                ),
              );
              Navigator.of(context).pop(); 
              _fetchStudentsData(); // Refresh the list
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color.fromARGB(255, 0, 255, 213),
                  content: Text("Changes Saved Successfully")));
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
bool _showSearchBar = false;
TextEditingController searchbarController = TextEditingController();

void _showSearchDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Search Name"),
        content: TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              // Perform search operation using the entered value
              _fetchStudentsData();
            });
          },
          decoration: InputDecoration(
            hintText: "Enter name to search",
          ),
        ),
        actions: <Widget>[
          FloatingActionButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  // Track search bar visibility

AppBar(
  title: Text("Student details"),
  actions: [
    IconButton(
      onPressed: () {
        setState(() {
          _showSearchBar = !_showSearchBar;
          if (_showSearchBar) {
            _showSearchDialog(context); // Show the search dialog
          }
        });
      },
      icon: Icon(Icons.search),
    ),
  ],
  backgroundColor: Colors.black,
),

      body: _studentsData.isEmpty
          ? Center(child: Text("No students available."))
          : ListView.builder(
              itemBuilder: (context, index) {
                final student = _studentsData[index];
                final id = student['id']; 
                final imageUrl = student['imageurl'];

                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StudentProfileScreen(
                            student: StudentModel.fromMap(student)),
                      ),
                    );
                  },
                  leading: GestureDetector(
                    onTap: () {
                      if (imageUrl != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.file(File(imageUrl)),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          imageUrl != null ? FileImage(File(imageUrl)) : null,
                      child: imageUrl == null ? Icon(Icons.person) : null,
                    ),
                  ),
                  title: Text(student['name']),
                  subtitle: Text(student['department']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showEditDialog(index);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext) => AlertDialog(
                              title: Text("Delete Student"),
                              content: Text("Are you sure you want to delete?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await deleteStudent(id); // Delete the student
                                    _fetchStudentsData(); // Refresh the list
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.red,
                                            content:
                                                Text("Deleted Successfully")));
                                  },
                                  child: Text("Ok"),
                                )
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            
              itemCount: _studentsData.length,
            ),
    );
  }
}
