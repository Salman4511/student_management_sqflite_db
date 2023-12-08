import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_managemnt_app/screens/infoscreen.dart';

import '../functions/functions.dart';
import 'model.dart';


class homescreen extends StatefulWidget {
  @override
  State<homescreen> createState() => _AddStudentState();
}

class _AddStudentState extends State<homescreen> {
  final _formKey = GlobalKey<FormState>();
  final regnoController = TextEditingController();
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController= TextEditingController();
  File? _selectedImage;

  void _setImage(File image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading:IconButton(onPressed: (){
        Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => infoscreen()),
    );
      }, icon: const Icon(Icons.menu)),
      title: const Text('Student login'),
      backgroundColor: Color.fromARGB(255, 35, 31, 31),
      
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.0LvP1YUJ2stgbrp2srwnFQHaHa?pid=ImgDet&w=203&h=203&c=7&dpr=1.3'),
                maxRadius: 70,
                child: GestureDetector(
                  onTap: () async {
                    File? pickedImage = await _pickImageFromCamera();
                    if (pickedImage != null) {
                      _setImage(pickedImage);
                    }
                  },
                  child: _selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        )
                      : const Icon(Icons.add_a_photo_rounded),
                ),
              ),
              SizedBox(height: 30),
               TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  if(value.length<4){
                    return 'Name is too short';
                  }
                  return null;
                },
                 onEditingComplete: () {
          FocusScope.of(context).nextFocus();
                      } 
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: regnoController,
                decoration: const InputDecoration(
                  labelText: "Reg No",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'ID is required';
                  }
                  return null;
                },
                 onEditingComplete: () {
          FocusScope.of(context).nextFocus();
                      }
              ),
              SizedBox(height: 20),
             
              TextFormField(
                keyboardType: TextInputType.name,
                controller: departmentController,
                decoration: const InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                 
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Department is required';
                  }
                  if (value.length < 2) {
                    return 'Department name must be at least 2 characters';
                  }
                  return null;
                },
                 onEditingComplete: () {
          FocusScope.of(context).nextFocus();
                      }
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email ID",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.mail),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email ID is required';
                  }
                 final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

                if (!emailRegExp.hasMatch(value)) {
                     return 'Invalid Email';
                    }
                  return null;
                },
                 onEditingComplete: () {
          FocusScope.of(context).unfocus();
                      }
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "phone",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone)),
                validator: (value){
                  if (value!.isEmpty){
                    return 'phone no is required';
                  }
                 
                },
                
              )
              ,SizedBox(height: 45),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Color.fromARGB(255, 255, 100, 28),
                          content: Text(
                            "Please select an image",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      return;
                    }

                    final student = StudentModel(
                      rollno: regnoController.text,
                      name: nameController.text,
                      department: departmentController.text,
                      email: emailController.text,
                      phone: phoneController,
                      imageurl: _selectedImage != null ? _selectedImage!.path : null,
                    );
                    await addStudent(student);
                   showDialog(
                    context: context,
                     builder: (BuildContext context) {
                     return AlertDialog(
                    backgroundColor: Colors.green,
                    content: const Text(
                     "Added Successfully",
                     style: TextStyle(
                    color: Colors.white,
                         ),
                       ),
                       actions: <Widget>[
                    TextButton(
                      onPressed: () {
                         Navigator.of(context).pop(); // Close the dialog
                        },
                          child: Text('OK'),
                              ),
                          ],
                          );
                         },
                            );

                    regnoController.clear();
                    nameController.clear();
                    departmentController.clear();
                    emailController.clear();
                    setState(() {
                      _selectedImage = null;
                    });
                  }
                },
                label: Text("ADD"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }
}
