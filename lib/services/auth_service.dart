import 'package:maverick/services/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabaseClient = supabaseInstanceClient;

  Future<AuthResponse> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logOut() async {
    return await _supabaseClient.auth.signOut();
  }
}
