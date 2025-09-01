import 'package:flutter/material.dart';
import 'package:maverick/features/auth/intro/onboarding.dart';
import 'package:maverick/screens/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to auth state
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        //Check of we have a valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return MainScreen();
        } else {
          // return LoginScreen(); replace with the onboarding screen
          return Onboarding();
        }
      },
    );
  }
}
