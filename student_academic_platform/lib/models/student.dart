class Student {
  final String email;
  final String password;
  final List<String> selectedCourses;

  Student({
    required this.email,
    required this.password,
    required this.selectedCourses,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'selectedCourses': selectedCourses,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      selectedCourses: List<String>.from(json['selectedCourses'] ?? []),
    );
  }
}
