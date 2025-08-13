import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maverick/core/utils/load_env.dart';
import 'package:maverick/features/auth/intro/onboarding.dart';
import 'package:maverick/services/auth_gate.dart';
import 'package:maverick/services/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await loadEnv();

  final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  final url = dotenv.env['SUPABASE_URL'];

  if (anonKey == null || url == null) {
    throw Exception("Missing SUPABASE_ANON_KEY or SUPABASE_URL in .env file");
  }
  await supabaseInitialisation(anonKey, url);
  // await dotenv.load(fileName: '.env');
  //
  // // Initialise supabase
  // final anonkey = dotenv.env['SUPABASE_ANON_KEY'];
  // final url = dotenv.env['SUPABASE_URL'];
  //
  // // Check null since Supabase doesn't non-nullable values
  // if (anonkey == null || url == null) {
  //   throw Exception("Missing SUPABASE_ANON_KEY or SUPABASE_URL in .env file");
  // }
  // await Supabase.initialize(anonKey: anonkey, url: url);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthGate());
  }
}
