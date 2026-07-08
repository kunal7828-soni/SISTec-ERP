// lib/Dashboards/StudentDashboard.dart

import 'package:flutter/material.dart';
import '../Auth/supabase_helper.dart';   // up one, into Auth/

// =====================================================
// MODEL
// =====================================================
class StudentUser {
  final String name;
  final String collegeName;
  final String academicYear;
  final double theoryAttendance;
  final double practicalAttendance;
  final double overallAttendance;

  StudentUser({
    required this.name,
    required this.collegeName,
    required this.academicYear,
    required this.theoryAttendance,
    required this.practicalAttendance,
    required this.overallAttendance,
  });

  factory StudentUser.fromRow(Map<String, dynamic> row) {
    return StudentUser(
      name: row['name'] ?? '',
      collegeName:
          'SAGAR INSTITUTE OF SCIENCE, TECHNOLOGY AND RESEARCH(SISTEC-R)',
      academicYear: '2026-2027',
      theoryAttendance: 0,
      practicalAttendance: 0,
      overallAttendance: 0,
    );
  }
}

// =====================================================
// SERVICE — fetches logged-in student from Supabase
// =====================================================
class StudentService {
  static Future<StudentUser?> fetchLoggedInStudent(String userCode) async {
    final row = await SupabaseHelper.getUserByCode(userCode);
    if (row == null) return null;
    return StudentUser.fromRow(row);
  }
}

// =====================================================
// DASHBOARD
// =====================================================
class StudentDashboard extends StatefulWidget {
  final String userCode;
  const StudentDashboard({super.key, required this.userCode});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  StudentUser? _student;
  bool _loading = true;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    final student =
        await StudentService.fetchLoggedInStudent(widget.userCode);
    if (!mounted) return;
    setState(() {
      _student = student;
      _loading = false;
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Night';
  }

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF0E7C66);

    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        body: Center(child: CircularProgressIndicator(color: tealColor)),
      );
    }

    if (_student == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF4F4F4),
        body: Center(child: Text('Student record not found')),
      );
    }

    final student = _student!;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.person, size: 36, color: Colors.grey),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_greeting(),
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700])),
                        const SizedBox(height: 2),
                        Text(
                          student.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // College info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  Text(
                    student.collegeName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                        height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  Text(student.academicYear,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333))),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Attendance
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Attendance',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333))),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: _AttendanceCircleCard(
                          label: 'Theory',
                          percent: student.theoryAttendance,
                          color: tealColor)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _AttendanceCircleCard(
                          label: 'Practical',
                          percent: student.practicalAttendance,
                          color: tealColor)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _AttendanceCircleCard(
                          label: 'Overall',
                          percent: student.overallAttendance,
                          color: tealColor)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Academic
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Academic',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333))),
                  const SizedBox(height: 20),
                  _AcademicGrid(
                    iconColor: tealColor,
                    items: const [
                      _AcademicItem(Icons.bar_chart, 'Dashboard'),
                      _AcademicItem(Icons.how_to_reg_outlined, 'Attendance'),
                      _AcademicItem(
                          Icons.event_note_outlined, 'Class Schedule'),
                      _AcademicItem(Icons.schedule, 'Exam Time Table'),
                      _AcademicItem(
                          Icons.badge_outlined, 'Exam Hall Ticket'),
                      _AcademicItem(Icons.emoji_events_outlined, 'Result'),
                      _AcademicItem(
                          Icons.assignment_outlined, 'Internal Mark'),
                      _AcademicItem(Icons.menu_book_outlined, 'ITLE'),
                      _AcademicItem(
                          Icons.receipt_long_outlined, 'Fees Paid'),
                      _AcademicItem(
                          Icons.bookmark_border, 'Register Subject'),
                      _AcademicItem(
                          Icons.calendar_month_outlined, 'Calendar'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _UnderlinedHeading(text: 'Services'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: tealColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Message'),
          BottomNavigationBarItem(
              icon: Icon(Icons.badge_outlined), label: 'Id Card'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), label: 'Notice'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// =====================================================
// REUSABLE WIDGETS
// =====================================================
class _AttendanceCircleCard extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;
  const _AttendanceCircleCard(
      {required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          SizedBox(
            width: 78,
            height: 78,
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                width: 78,
                height: 78,
                child: CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 6,
                  backgroundColor: const Color(0xFFE9E9E9),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text('${percent.toStringAsFixed(0)}%',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333))),
            ]),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333))),
        ],
      ),
    );
  }
}

class _AcademicItem {
  final IconData icon;
  final String label;
  const _AcademicItem(this.icon, this.label);
}

class _AcademicGrid extends StatelessWidget {
  final List<_AcademicItem> items;
  final Color iconColor;
  const _AcademicGrid({required this.items, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFDDDDDD))),
                child: Icon(item.icon, color: iconColor, size: 26),
              ),
              const SizedBox(height: 8),
              Text(item.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12.5, color: Color(0xFF444444))),
            ],
          ),
        );
      },
    );
  }
}

class _UnderlinedHeading extends StatelessWidget {
  final String text;
  const _UnderlinedHeading({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333))),
        const SizedBox(height: 6),
        Container(width: 40, height: 3, color: const Color(0xFF0E7C66)),
      ],
    );
  }
}