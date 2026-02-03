import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';

class DataService {
  static const String _studentKey = 'student_data';
  static const String _assignmentsKey = 'assignments_data';
  static const String _sessionsKey = 'sessions_data';

  // Save Student Data
  Future<void> saveStudent(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentKey, jsonEncode(student.toJson()));
  }

  // Get Student Data
  Future<Student?> getStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final studentData = prefs.getString(_studentKey);
    if (studentData != null) {
      return Student.fromJson(jsonDecode(studentData));
    }
    return null;
  }

  // Save Assignments
  Future<void> saveAssignments(List<Assignment> assignments) async {
    final prefs = await SharedPreferences.getInstance();
    final assignmentsJson = assignments.map((a) => a.toJson()).toList();
    await prefs.setString(_assignmentsKey, jsonEncode(assignmentsJson));
  }

  // Get Assignments
  Future<List<Assignment>> getAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final assignmentsData = prefs.getString(_assignmentsKey);
    if (assignmentsData != null) {
      final List<dynamic> jsonList = jsonDecode(assignmentsData);
      return jsonList.map((json) => Assignment.fromJson(json)).toList();
    }
    return [];
  }

  // Save Sessions
  Future<void> saveSessions(List<AcademicSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = sessions.map((s) => s.toJson()).toList();
    await prefs.setString(_sessionsKey, jsonEncode(sessionsJson));
  }

  // Get Sessions
  Future<List<AcademicSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsData = prefs.getString(_sessionsKey);
    if (sessionsData != null) {
      final List<dynamic> jsonList = jsonDecode(sessionsData);
      return jsonList.map((json) => AcademicSession.fromJson(json)).toList();
    }
    return [];
  }

  // Calculate Attendance Percentage
  double calculateAttendancePercentage(List<AcademicSession> sessions) {
    if (sessions.isEmpty) return 0.0;
    final attendedCount = sessions.where((s) => s.isAttended).length;
    return (attendedCount / sessions.length) * 100;
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
