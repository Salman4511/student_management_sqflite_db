import 'dart:io';

import 'package:flutter/material.dart';

import 'model.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentModel student;

  StudentProfileScreen({required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Profile"),
        backgroundColor: Color.fromARGB(255, 21, 26, 27),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundImage: student.imageurl != null
                  ? FileImage(File(student.imageurl!))
                  : null,
            ),
            if (student.imageurl == null)
              Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.camera_alt, size: 30),
              ),
            SizedBox(height: 20),
            Text(
              student.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Reg No: ${student.rollno.toString()}",
                style: TextStyle(fontSize: 15,), textAlign: TextAlign.center),
            SizedBox(height: 10),
            Text("Department: ${student.department}",
                style: TextStyle(fontSize: 15)),
            SizedBox(height: 10,),
            Text("EmailID: ${student.email}",
                style: TextStyle(fontSize: 15,)),
          ],
        ),
      ),
    );
  }
}
