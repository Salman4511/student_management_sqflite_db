class StudentModel {
  int? id; // Make id field an integer and required
  final dynamic rollno;
  final String name;
  final String department;
  final dynamic email;
  final dynamic phone;
  final String? imageurl; // Nullable field for image URL

  StudentModel({
     this.id,
    required this.rollno,
    required this.name,
    required this.department,
    required this.email,
    required this.phone,
    this.imageurl,
  });

  static fromMap(Map<String, dynamic> student) {
    return StudentModel(
      id: student['id'],
      rollno: student['regno'],
      name: student['name'],
      department: student['department'],
      email: student['email'],
      phone :student['phone'],
      imageurl: student['imageurl'],
    );
  }
}
