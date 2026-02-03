import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';
import '../services/data_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DataService _dataService = DataService();
  List<Assignment> _assignments = [];
  List<AcademicSession> _sessions = [];
  double _attendancePercentage = 0.0;
  bool _isLoading = true;
  List<String> _selectedCourses = [];
  String _currentCourse = 'All Selected Courses';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Load student courses
    final student = await _dataService.getStudent();
    final assignments = await _dataService.getAssignments();
    final sessions = await _dataService.getSessions();
    final attendancePercentage = _dataService.calculateAttendancePercentage(sessions);

    setState(() {
      _selectedCourses = student?.selectedCourses ?? [];
      _assignments = assignments;
      _sessions = sessions;
      _attendancePercentage = attendancePercentage;
      _isLoading = false;
    });
  }

  List<Assignment> _getUpcomingAssignments() {
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(const Duration(days: 7));
    
    return _assignments
        .where((assignment) =>
            !assignment.isCompleted &&
            assignment.dueDate.isAfter(now) &&
            assignment.dueDate.isBefore(sevenDaysFromNow))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  List<AcademicSession> _getTodaySessions() {
    final now = DateTime.now();
    return _sessions
        .where((session) =>
            session.date.year == now.year &&
            session.date.month == now.month &&
            session.date.day == now.day)
        .toList();
  }

  int _getActiveProgressCount() {
    return _assignments.where((a) => !a.isCompleted).length;
  }

  int _getCodeTeardowsCount() {
    // This is a placeholder - you can implement logic based on your needs
    return _sessions.where((s) => s.sessionType == 'Mastery Session').length;
  }

  int _getUpcomingAgentsCount() {
    // This is a placeholder - you can implement logic based on your needs
    final now = DateTime.now();
    return _sessions
        .where((s) =>
            s.date.isAfter(now) &&
            s.date.isBefore(now.add(const Duration(days: 7))))
        .length;
  }

  String _getCurrentAcademicWeek() {
    final now = DateTime.now();
    // Assuming academic year starts in September
    final academicYearStart = DateTime(
      now.month >= 9 ? now.year : now.year - 1,
      9,
      1,
    );
    final weekNumber = now.difference(academicYearStart).inDays ~/ 7 + 1;
    return 'Week $weekNumber';
  }

  Color _getAttendanceColor() {
    if (_attendancePercentage >= 75) return ALUColors.attendanceGood;
    if (_attendancePercentage >= 60) return ALUColors.attendanceWarning;
    return ALUColors.attendanceCritical;
  }

  @override
  Widget build(BuildContext context) {
    final todayDate = DateFormat('EEEE, MMM d').format(DateTime.now());
    final upcomingAssignments = _getUpcomingAssignments();
    final todaySessions = _getTodaySessions();

    return Scaffold(
      backgroundColor: ALUColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: ALUColors.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ALUColors.textWhite),
          onPressed: () {},
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: ALUColors.textWhite),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: ALUColors.textWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ALUColors.accentYellow,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              color: ALUColors.accentYellow,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Selector Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ALUColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _currentCourse,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: ALUColors.cardBackground,
                        style: const TextStyle(
                          color: ALUColors.textWhite,
                          fontSize: 14,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: ALUColors.textWhite,
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: 'All Selected Courses',
                            child: Text('All Selected Courses'),
                          ),
                          ..._selectedCourses.map((course) {
                            return DropdownMenuItem(
                              value: course,
                              child: Text(course),
                            );
                          }),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _currentCourse = newValue!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // At Risk Warning (if attendance < 75%)
                    if (_attendancePercentage < 75)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ALUColors.warningRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.warning,
                              color: ALUColors.textWhite,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'AT RISK WARNING',
                                style: TextStyle(
                                  color: ALUColors.textWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (_attendancePercentage < 75) const SizedBox(height: 16),

                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '${_getActiveProgressCount()}',
                            'Active\nProgress',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            '${_getCodeTeardowsCount()}',
                            'Code\nTeardowns',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            '${_getUpcomingAgentsCount()}',
                            'Upcoming\nAgents',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Today's Date and Week
                    Text(
                      todayDate,
                      style: const TextStyle(
                        color: ALUColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _getCurrentAcademicWeek(),
                      style: const TextStyle(
                        color: ALUColors.textGray,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Today's Classes
                    const Text(
                      "Today's Classes",
                      style: TextStyle(
                        color: ALUColors.textWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (todaySessions.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ALUColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'No classes scheduled for today',
                            style: TextStyle(
                              color: ALUColors.textGray,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      ...todaySessions.map((session) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildSessionCard(session),
                          )),

                    const SizedBox(height: 24),

                    // Upcoming Assignments (Due in 7 Days)
                    const Text(
                      'Upcoming Assignments',
                      style: TextStyle(
                        color: ALUColors.textWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (upcomingAssignments.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ALUColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'No assignments due in the next 7 days',
                            style: TextStyle(
                              color: ALUColors.textGray,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      ...upcomingAssignments.map((assignment) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildAssignmentCard(assignment),
                          )),

                    const SizedBox(height: 24),

                    // Attendance Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ALUColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Overall Attendance',
                            style: TextStyle(
                              color: ALUColors.textWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getAttendanceColor(),
                            ),
                            child: Center(
                              child: Text(
                                '${_attendancePercentage.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: ALUColors.textWhite,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_attendancePercentage < 75)
                            const Text(
                              'Warning: Attendance below 75%',
                              style: TextStyle(
                                color: ALUColors.warningRed,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ALUColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: ALUColors.textWhite,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: ALUColors.textGray,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(AcademicSession session) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ALUColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    color: ALUColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.startTime} - ${session.endTime}',
                  style: const TextStyle(
                    color: ALUColors.textGray,
                    fontSize: 14,
                  ),
                ),
                if (session.location.isNotEmpty)
                  Text(
                    session.location,
                    style: const TextStyle(
                      color: ALUColors.textGray,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: ALUColors.textWhite,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final daysUntilDue = assignment.dueDate.difference(DateTime.now()).inDays;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ALUColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  style: const TextStyle(
                    color: ALUColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due ${DateFormat('MMM d').format(assignment.dueDate)}',
                  style: const TextStyle(
                    color: ALUColors.textGray,
                    fontSize: 14,
                  ),
                ),
                if (daysUntilDue <= 2)
                  Text(
                    'Due in $daysUntilDue days',
                    style: const TextStyle(
                      color: ALUColors.warningRed,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: ALUColors.textWhite,
          ),
        ],
      ),
    );
  }
}
