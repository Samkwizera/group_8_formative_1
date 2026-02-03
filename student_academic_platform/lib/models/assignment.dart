class Assignment {
  final String id;
  final String title;
  final DateTime dueDate;
  final String course;
  final String priority; // High, Medium, Low
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.course,
    this.priority = 'Medium',
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'course': course,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      dueDate: DateTime.parse(json['dueDate']),
      course: json['course'] ?? '',
      priority: json['priority'] ?? 'Medium',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
