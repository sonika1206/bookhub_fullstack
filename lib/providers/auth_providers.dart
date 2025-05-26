import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;
  
  AuthState({this.isLoading = false, this.errorMessage, this.user});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    // Just listen to auth changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      state = AuthState(user: data.session?.user);
    });
  }
  
  void setLoading(bool loading) => state = AuthState(user: state.user, isLoading: loading);
  void setError(String? error) => state = AuthState(user: state.user, errorMessage: error);
}