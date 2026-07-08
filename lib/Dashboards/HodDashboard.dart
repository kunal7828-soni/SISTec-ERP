// lib/Dashboards/HodDashboard.dart

import 'package:flutter/material.dart';

class HodDashboard extends StatelessWidget {
  final String userCode;
  const HodDashboard({super.key, required this.userCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HOD Dashboard')),
      body: Center(child: Text('Welcome, $userCode')),
    );
  }
}