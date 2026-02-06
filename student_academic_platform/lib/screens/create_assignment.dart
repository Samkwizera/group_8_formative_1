import 'package:flutter/material.dart';

class CreateAssignmentScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  CreateAssignmentScreen({super.key, this.initialData});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _courseController;
  late TextEditingController _dueDateController;

  String _priority = "Medium";
  String _type = "Formative"; // NEW
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;

    _titleController =
        TextEditingController(text: data != null ? data["title"] : "");
    _courseController =
        TextEditingController(text: data != null ? data["course"] : "");
    _dueDateController =
        TextEditingController(text: data != null ? data["due"] : "");
    _priority = data != null ? data["priority"] : "Medium";
    _type = data != null ? data["type"] : "Formative";
    _completed = data != null ? (data["completed"] ?? false) : false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  // ================= SUBMIT =================
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final assignment = {
        "title": _titleController.text.trim(),
        "course": _courseController.text.trim(),
        "due": _dueDateController.text.trim(),
        "priority": _priority,
        "type": _type,
        "completed": _completed,
      };

      Navigator.pop(context, assignment);
    }
  }

  // ================= DATE PICKER =================
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      _dueDateController.text =
          "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F),
        elevation: 0,
        title: const Text("Create Assignment"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Assignment Title"),
              _buildTextField(controller: _titleController, hint: "Enter title"),
              const SizedBox(height: 20),
              _buildLabel("Course"),
              _buildTextField(controller: _courseController, hint: "Enter course"),
              const SizedBox(height: 20),
              _buildLabel("Due Date"),
              _buildDateField(),
              const SizedBox(height: 20),
              _buildLabel("Priority"),
              _buildPriorityDropdown(),
              const SizedBox(height: 20),
              _buildLabel("Assignment Type"),
              _buildTypeDropdown(),
              const SizedBox(height: 20),
              _buildLabel("Completed"),
              Switch(
                value: _completed,
                onChanged: (value) {
                  setState(() => _completed = value);
                },
                activeColor: Colors.green,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDB827),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    "Save Assignment",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= WIDGETS =================
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(hint),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Required field";
        }
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dueDateController,
      readOnly: true,
      onTap: _pickDate,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration("Select date").copyWith(
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Select date";
        return null;
      },
    );
  }

  Widget _buildPriorityDropdown() {
    return _buildDropdown(
      value: _priority,
      items: const ["High", "Medium", "Low"],
      onChanged: (value) {
        if (value != null) setState(() => _priority = value);
      },
    );
  }

  Widget _buildTypeDropdown() {
    return _buildDropdown(
      value: _type,
      items: const ["Formative", "Summative"],
      onChanged: (value) {
        if (value != null) setState(() => _type = value);
      },
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2540),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: const Color(0xFF0A2540),
        iconEnabledColor: Colors.white,
        decoration: const InputDecoration(border: InputBorder.none),
        style: const TextStyle(color: Colors.white),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF0A2540),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
