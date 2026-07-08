import 'package:supabase_flutter/supabase_flutter.dart';

// Single access point for the Supabase client
final supabase = Supabase.instance.client;

class SupabaseHelper {
  // LOGIN: query Users table for matching user_code + password
  static Future<Map<String, dynamic>?> login(
      String userCode, String password) async {
    final response = await supabase
        .from('Users')
        .select()
        .eq('user_code', userCode)
        .eq('password', password)
        .maybeSingle();
    return response;
  }

  // GET USER: fetch a user's full row by user_code (used by dashboards)
  static Future<Map<String, dynamic>?> getUserByCode(String userCode) async {
    final response = await supabase
        .from('Users')
        .select()
        .eq('user_code', userCode)
        .maybeSingle();
    return response;
  }
}