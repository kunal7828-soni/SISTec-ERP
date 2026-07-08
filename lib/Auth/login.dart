// lib/Auth/login.dart

import 'package:flutter/material.dart';
import 'supabase_helper.dart';                       // same folder: Auth/
import '../Dashboards/StudentDashboard.dart';        // up one, into Dashboards/
import '../Dashboards/FacultyDashboard.dart';
import '../Dashboards/HodDashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String? _errorText;

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final userCode = _userIdController.text.trim();
    final password = _passwordController.text.trim();

    if (userCode.isEmpty || password.isEmpty) {
      setState(() => _errorText = 'Please enter both UserID and Password');
      return;
    }

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final user = await SupabaseHelper.login(userCode, password);

      if (!mounted) return;
      setState(() => _loading = false);

      if (user == null) {
        setState(() => _errorText = 'Invalid UserID or Password');
        return;
      }

      final role = (user['role'] as String).toUpperCase();

      if (!mounted) return;

      if (role == 'STUDENT') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDashboard(userCode: userCode),
          ),
        );
      } else if (role == 'FACULTY') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FacultyDashboard(userCode: userCode),
          ),
        );
      } else if (role == 'HOD') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HodDashboard(userCode: userCode),
          ),
        );
      } else {
        setState(() => _errorText = 'Unknown role: $role');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorText = 'Connection error. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF0E7C66);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school_outlined, size: 72, color: teal),
              const SizedBox(height: 12),
              const Text(
                'SISTEC-R ERP',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 36),

              // UserID
              TextField(
                controller: _userIdController,
                decoration: InputDecoration(
                  labelText: 'UserID',
                  hintText: 'e.g. 0537CS241061',
                  prefixIcon: const Icon(Icons.person_outline, color: teal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: teal, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: teal),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: teal, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: teal,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(_errorText!,
                    style:
                        const TextStyle(color: Colors.red, fontSize: 13)),
              ],

              const SizedBox(height: 28),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Login',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}