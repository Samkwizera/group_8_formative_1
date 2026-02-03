import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/main_navigation.dart';
import 'services/data_service.dart';
import 'constants/colors.dart';

void main() {
  runApp(const StudentAcademicPlatformApp());
}

class StudentAcademicPlatformApp extends StatelessWidget {
  const StudentAcademicPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Student Academic Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ALUColors.primaryDark,
        scaffoldBackgroundColor: ALUColors.backgroundDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ALUColors.accentYellow,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const InitialScreen(),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final DataService _dataService = DataService();
  bool _isLoading = true;
  bool _isSignedUp = false;

  @override
  void initState() {
    super.initState();
    _checkSignUpStatus();
  }

  Future<void> _checkSignUpStatus() async {
    final student = await _dataService.getStudent();
    setState(() {
      _isSignedUp = student != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: ALUColors.backgroundDark,
        body: Center(
          child: CircularProgressIndicator(
            color: ALUColors.accentYellow,
          ),
        ),
      );
    }

    return _isSignedUp ? const MainNavigation() : const SignUpScreen();
  }
}
