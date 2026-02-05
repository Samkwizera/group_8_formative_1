import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('student_academic.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Student table
    await db.execute('''
      CREATE TABLE students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        selectedCourses TEXT NOT NULL
      )
    ''');

    // Assignments table
    await db.execute('''
      CREATE TABLE assignments(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        course TEXT NOT NULL,
        priority TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');

    // Academic Sessions table
    await db.execute('''
      CREATE TABLE academic_sessions(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        location TEXT,
        sessionType TEXT NOT NULL,
        isAttended INTEGER NOT NULL
      )
    ''');
  }

  // Student Operations
  Future<void> insertStudent(Student student) async {
    final db = await database;
    
    // Delete existing student data (single user app)
    await db.delete('students');
    
    await db.insert(
      'students',
      {
        'email': student.email,
        'password': student.password,
        'selectedCourses': student.selectedCourses.join(','),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Student?> getStudent() async {
    final db = await database;
    final maps = await db.query('students', limit: 1);

    if (maps.isEmpty) return null;

    return Student(
      email: maps.first['email'] as String,
      password: maps.first['password'] as String,
      selectedCourses: (maps.first['selectedCourses'] as String).split(','),
    );
  }

  // Assignment Operations
  Future<void> insertAssignment(Assignment assignment) async {
    final db = await database;
    await db.insert(
      'assignments',
      {
        'id': assignment.id,
        'title': assignment.title,
        'dueDate': assignment.dueDate.toIso8601String(),
        'course': assignment.course,
        'priority': assignment.priority,
        'isCompleted': assignment.isCompleted ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Assignment>> getAssignments() async {
    final db = await database;
    final maps = await db.query('assignments');

    return maps.map((map) => Assignment(
      id: map['id'] as String,
      title: map['title'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      course: map['course'] as String,
      priority: map['priority'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
    )).toList();
  }

  Future<void> updateAssignment(Assignment assignment) async {
    final db = await database;
    await db.update(
      'assignments',
      {
        'title': assignment.title,
        'dueDate': assignment.dueDate.toIso8601String(),
        'course': assignment.course,
        'priority': assignment.priority,
        'isCompleted': assignment.isCompleted ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [assignment.id],
    );
  }

  Future<void> deleteAssignment(String id) async {
    final db = await database;
    await db.delete(
      'assignments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Academic Session Operations
  Future<void> insertSession(AcademicSession session) async {
    final db = await database;
    await db.insert(
      'academic_sessions',
      {
        'id': session.id,
        'title': session.title,
        'date': session.date.toIso8601String(),
        'startTime': session.startTime,
        'endTime': session.endTime,
        'location': session.location,
        'sessionType': session.sessionType,
        'isAttended': session.isAttended ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AcademicSession>> getSessions() async {
    final db = await database;
    final maps = await db.query('academic_sessions');

    return maps.map((map) => AcademicSession(
      id: map['id'] as String,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      location: map['location'] as String? ?? '',
      sessionType: map['sessionType'] as String,
      isAttended: (map['isAttended'] as int) == 1,
    )).toList();
  }

  Future<void> updateSession(AcademicSession session) async {
    final db = await database;
    await db.update(
      'academic_sessions',
      {
        'title': session.title,
        'date': session.date.toIso8601String(),
        'startTime': session.startTime,
        'endTime': session.endTime,
        'location': session.location,
        'sessionType': session.sessionType,
        'isAttended': session.isAttended ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<void> deleteSession(String id) async {
    final db = await database;
    await db.delete(
      'academic_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('students');
    await db.delete('assignments');
    await db.delete('academic_sessions');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
