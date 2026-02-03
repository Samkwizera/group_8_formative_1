import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ALUColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: ALUColors.backgroundDark,
        elevation: 0,
        title: const Text(
          'Assignments',
          style: TextStyle(color: ALUColors.textWhite),
        ),
      ),
      body: const Center(
        child: Text(
          'Assignments Screen\n(To be implemented by team)',
          style: TextStyle(
            color: ALUColors.textWhite,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
