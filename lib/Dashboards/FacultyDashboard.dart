// lib/Dashboards/FacultyDashboard.dart

import 'package:flutter/material.dart';

class FacultyDashboard extends StatelessWidget {
  final String userCode;
  const FacultyDashboard({super.key, required this.userCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faculty Dashboard')),
      body: Center(child: Text('Welcome, $userCode')),
    );
  }
}