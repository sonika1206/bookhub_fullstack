
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  Future<void> signIn({required String email, required String password}) async {
    print('AuthService: Attempting signIn with email: $email');
    try {
      await _client.auth
          .signInWithPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 100),
            onTimeout: () {
              throw TimeoutException('Login request timed out');
            },
          );
      print('AuthService: SignIn successful');
    } catch (e) {
      print('AuthService: SignIn error: $e');
      rethrow;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

 

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<Map<String, dynamic>?> getProfile(String profileId) async {
    final response =
        await _client
            .from('profiles')
            .select()
            .eq('id', profileId)
            .maybeSingle();
    return response;
  }

  Session? getCurrentSession() => _client.auth.currentSession;
  User? getCurrentUser() => _client.auth.currentUser;
}