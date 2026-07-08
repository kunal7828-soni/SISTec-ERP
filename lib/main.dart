// lib/main.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mwawpgnqyejdzdibcleb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im13YXdwZ25xeWVqZHpkaWJjbGViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM0ODQzMTIsImV4cCI6MjA5OTA2MDMxMn0.6xu0j9voVlna4Yh7rWuQ4ZchLp0gteeEGdLKso-ZwCE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}