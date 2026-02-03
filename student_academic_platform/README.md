# Student Academic Platform - ALU

A mobile application that serves as a personal academic assistant for African Leadership University (ALU) students.

## Project Overview

This Flutter application helps ALU students organize their coursework, track their schedule, and monitor their academic engagement throughout the term.

## What Has Been Implemented (Phase 1)

### ✅ Project Setup
- Flutter project initialized with proper structure
- Dependencies installed:
  - `shared_preferences` for local data storage
  - `intl` for date formatting
- ALU brand colors configured (Dark Navy #001F3F, Yellow #FDB827, Red #DC3545)

### ✅ Sign-Up Screen
- Email and password input fields with validation
- Course selection interface (multi-select)
- ALU-themed UI with dark navy background and yellow buttons
- Data persistence using SharedPreferences

### ✅ Dashboard Screen
- Displays today's date and current academic week
- Shows warning banner when attendance falls below 75%
- Three stat cards showing:
  - Active Progress (pending assignments)
  - Code Teardowns (mastery sessions)
  - Upcoming Agents (upcoming sessions)
- Today's classes list
- Upcoming assignments (due within 7 days)
- Overall attendance percentage with visual color indicator:
  - Green (≥75%): Good attendance
  - Yellow (60-74%): Warning
  - Red (<60%): Critical
- Pull-to-refresh functionality

### ✅ Navigation Structure
- Bottom navigation bar with 3 tabs:
  - Dashboard
  - Assignments (placeholder)
  - Schedule (placeholder)

### ✅ Data Models
- **Student**: email, password, selectedCourses
- **Assignment**: id, title, dueDate, course, priority, isCompleted
- **AcademicSession**: id, title, date, startTime, endTime, location, sessionType, isAttended

### ✅ Data Service
- Save and retrieve student data
- Save and retrieve assignments
- Save and retrieve academic sessions
- Calculate attendance percentage
- All data persists using SharedPreferences

## Project Structure

```
lib/
├── constants/
│   └── colors.dart              # ALU brand colors
├── models/
│   ├── student.dart             # Student data model
│   ├── assignment.dart          # Assignment data model
│   └── academic_session.dart    # Session data model
├── screens/
│   ├── signup_screen.dart       # Sign-up interface ✅
│   ├── dashboard_screen.dart    # Dashboard interface ✅
│   ├── assignments_screen.dart  # Placeholder for team
│   ├── schedule_screen.dart     # Placeholder for team
│   └── main_navigation.dart     # Bottom navigation ✅
├── services/
│   └── data_service.dart        # Data management ✅
└── main.dart                    # App entry point ✅
```

## For Team Members

The following screens are placeholders and ready for implementation:

### 🔲 Assignments Screen
**Requirements:**
- Create new assignments (title, due date, course, priority)
- View all assignments sorted by due date
- Filter by: All, Formative, Summative
- Mark assignments as completed
- Edit assignment details
- Delete assignments

### 🔲 Schedule Screen
**Requirements:**
- Weekly calendar view
- Add new academic sessions (title, date, start/end time, location, type)
- Session types: Class, Mastery Session, Study Group, PSL Meeting
- Present/Absent toggle for each session
- Edit session details
- Delete sessions

**Note:** Use the existing data models and DataService - they're already set up for your screens!

## Running the App

1. Ensure Flutter is installed: `flutter --version`
2. Get dependencies: `flutter pub get`
3. Run the app: `flutter run`

## Testing the App

### First Time:
1. Launch the app - you'll see the Sign-Up screen
2. Enter email and password
3. Select at least one course
4. Click "Sign Up"
5. You'll be navigated to the Dashboard

### Subsequent Launches:
- The app remembers your sign-up and goes directly to the Dashboard

### Testing Dashboard Features:
Since you won't have data initially, you can add test data by:
1. Implementing the Assignments and Schedule screens
2. Or programmatically adding data through the DataService

## Color Palette

```dart
Primary Dark: #001F3F (Dark Navy Blue)
Accent Yellow: #FDB827 (Gold/Yellow for buttons)
Warning Red: #DC3545 (For alerts and warnings)
Text White: #FFFFFF
Text Gray: #B0B0B0
Card Background: #0A2540
Card Light Background: #1A3550
```

## Key Features for Dashboard

- ✅ Real-time attendance calculation
- ✅ Visual warning system (red banner when < 75%)
- ✅ Automatic filtering of today's sessions
- ✅ Automatic filtering of assignments due within 7 days
- ✅ Academic week calculation
- ✅ Responsive UI with no pixel overflow
- ✅ Pull-to-refresh functionality

## Next Steps for Team

1. **Assignments Screen**: Implement CRUD operations for assignments
2. **Schedule Screen**: Implement CRUD operations for sessions with calendar view
3. **Enhanced Dashboard**: Add more interactive features (tap on assignments/sessions to view details)
4. **Data Validation**: Add more robust input validation
5. **Testing**: Add unit tests and widget tests

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2  # Local data storage
  intl: ^0.19.0              # Date formatting
```

## Notes

- Data persists locally using SharedPreferences
- No backend/API integration required for this phase
- All dates are calculated relative to current date
- Academic week assumes semester starts in September

---

**Built for African Leadership University**
*Empowering students to manage their academic journey*
