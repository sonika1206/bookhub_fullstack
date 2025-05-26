import 'package:supabase_flutter/supabase_flutter.dart';

class AppConfig {
 static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    Supabase.initialize(
    url: "https://eqgedtocizmklqmtlllf.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVxZ2VkdG9jaXpta2xxbXRsbGxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc5NDk4MzcsImV4cCI6MjA2MzUyNTgzN30.r3fd3t0x-ZSJrhIOC3qdL346MZRYOWFnACG9HPkJcAY",
  );
  }

}