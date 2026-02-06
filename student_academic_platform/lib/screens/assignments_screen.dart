import 'package:flutter/material.dart';
import 'create_assignment.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> assignments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      case "Low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F),
        elevation: 0,
        title: const Text("Assignments"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFDB827),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Formative"),
            Tab(text: "Summative"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAssignmentList("All"),
          _buildAssignmentList("Formative"),
          _buildAssignmentList("Summative"),
        ],
      ),
    );
  }

  Widget _buildAssignmentList(String type) {
    final filtered = type == "All"
        ? assignments
        : assignments.where((a) => a["type"] == type).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDB827),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text("Create Assignment", style: TextStyle(fontSize: 18)),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateAssignmentScreen(),
                ),
              );

              if (result != null) {
                setState(() {
                  assignments.add({
                    "title": result["title"],
                    "course": result["course"],
                    "due": result["due"],
                    "priority": result["priority"],
                    "type": result["type"],
                    "completed": result["completed"] ?? false,
                    "priorityColor": _getPriorityColor(result["priority"]),
                  });
                });
              }
            },
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _buildAssignmentCard(
                      title: item["title"],
                      due: item["due"],
                      course: item["course"],
                      priority: item["priority"],
                      priorityColor: item["priorityColor"],
                      completed: item["completed"] ?? false,
                      index: assignments.indexOf(item),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.assignment_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No Assignments Yet",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("Tap 'Create Assignment' to get started", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard({
    required String title,
    required String due,
    required String course,
    required String priority,
    required Color priorityColor,
    required bool completed,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: completed ? Colors.grey[800] : const Color(0xFF0A2540),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text("Due $due", style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildCircleButton(Icons.check, Colors.green, onTap: () {
                        setState(() {
                          assignments[index]["completed"] = !completed;
                        });
                      }),
                      const SizedBox(width: 8),
                      _buildCircleButton(Icons.edit, const Color(0xFFFDB827), onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAssignmentScreen(initialData: assignments[index]),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            assignments[index] = {
                              "title": result["title"],
                              "course": result["course"],
                              "due": result["due"],
                              "priority": result["priority"],
                              "type": result["type"],
                              "completed": result["completed"] ?? false,
                              "priorityColor": _getPriorityColor(result["priority"]),
                            };
                          });
                        }
                      }),
                      const SizedBox(width: 8),
                      _buildCircleButton(Icons.delete, Colors.red, onTap: () {
                        setState(() {
                          assignments.removeAt(index);
                        });
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildTag(course, Colors.blueGrey),
                  const SizedBox(width: 8),
                  _buildTag(priority, priorityColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(radius: 18, backgroundColor: color, child: Icon(icon, size: 18, color: Colors.white)),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }
}
