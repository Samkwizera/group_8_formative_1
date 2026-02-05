import '../models/student.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';
import 'database_helper.dart';

class DataService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Save Student Data
  Future<void> saveStudent(Student student) async {
    await _dbHelper.insertStudent(student);
  }

  // Get Student Data
  Future<Student?> getStudent() async {
    return await _dbHelper.getStudent();
  }

  // Assignment Operations
  Future<void> saveAssignments(List<Assignment> assignments) async {
    // Insert all assignments
    for (var assignment in assignments) {
      await _dbHelper.insertAssignment(assignment);
    }
  }

  Future<List<Assignment>> getAssignments() async {
    return await _dbHelper.getAssignments();
  }

  Future<void> addAssignment(Assignment assignment) async {
    await _dbHelper.insertAssignment(assignment);
  }

  Future<void> updateAssignment(Assignment assignment) async {
    await _dbHelper.updateAssignment(assignment);
  }

  Future<void> deleteAssignment(String id) async {
    await _dbHelper.deleteAssignment(id);
  }

  // Session Operations
  Future<void> saveSessions(List<AcademicSession> sessions) async {
    // Insert all sessions
    for (var session in sessions) {
      await _dbHelper.insertSession(session);
    }
  }

  Future<List<AcademicSession>> getSessions() async {
    return await _dbHelper.getSessions();
  }

  Future<void> addSession(AcademicSession session) async {
    await _dbHelper.insertSession(session);
  }

  Future<void> updateSession(AcademicSession session) async {
    await _dbHelper.updateSession(session);
  }

  Future<void> deleteSession(String id) async {
    await _dbHelper.deleteSession(id);
  }

  // Calculate Attendance Percentage
  double calculateAttendancePercentage(List<AcademicSession> sessions) {
    if (sessions.isEmpty) return 0.0;
    final attendedCount = sessions.where((s) => s.isAttended).length;
    return (attendedCount / sessions.length) * 100;
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _dbHelper.clearAllData();
  }
}
