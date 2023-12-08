import 'package:sqflite/sqflite.dart';

import '../screens/model.dart';


late Database _dbs;

Future<void> initializeDatabase() async {
  _dbs = await openDatabase(
    "student.dbs",
    version: 2,
    onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE student (id INTEGER PRIMARY KEY, regno INTEGER, name TEXT, department TEXT, email TEXT, imageurl);",
      );
    },onUpgrade:(db, oldVersion, newVersion) async{
      await db.execute("ALTER TABLE student ADD COLUMN phone INTEGER");
    },
  
  );
}

Future<void> addStudent(StudentModel value) async {
  await _dbs.rawInsert(
    "INSERT INTO student (id, regno, name, department, email, imageurl) VALUES (?, ?, ?, ?, ?, ?)",
    [value.id, value.rollno, value.name, value.department, value.email, value.imageurl],
  );
}

Future<List<Map<String, dynamic>>> getAllStudents() async {
  final _values = await _dbs.rawQuery("SELECT * FROM student");
  return _values;
}

Future<void> deleteStudent(int id) async {
  await _dbs.rawDelete('DELETE FROM student WHERE id = ?', [id]);
}

Future<void> updateStudent(StudentModel updatedStudent) async {
  await _dbs.update(
    'student',
    {
      'regno': updatedStudent.rollno,
      'name': updatedStudent.name,
      'department': updatedStudent.department,
      'email': updatedStudent.email,
      'imageurl': updatedStudent.imageurl,
    },
    where: 'id = ?',
    whereArgs: [updatedStudent.id],
  );
}
