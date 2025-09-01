import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maverick/models/group.dart';
import 'package:maverick/models/members.dart';
import 'package:maverick/models/transaction.dart';
import 'package:maverick/services/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 2));
  // await loadEnv();
  //
  // final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  // final url = dotenv.env['SUPABASE_URL'];
  //
  // if (anonKey == null || url == null) {
  //   throw Exception("Missing SUPABASE_ANON_KEY or SUPABASE_URL in .env file");
  // }
  // await supabaseInitialisation(anonKey, url);
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter(); // initialise hive

  Hive.registerAdapter(GroupModelAdapter()); // register our GroupHiveModel
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(MemberModelAdapter());
  await Hive.openBox<MemberModel>('members');
  await Hive.openBox<GroupModel>('groups');
  await Hive.openBox<TransactionModel>('transactions');

  // Initialise supabase
  final anonkey = dotenv.env['SUPABASE_ANON_KEY'];
  final url = dotenv.env['SUPABASE_URL'];

  // Check null since Supabase doesn't non-nullable values
  if (anonkey == null || url == null) {
    throw Exception("Missing SUPABASE_ANON_KEY or SUPABASE_URL in .env file");
  }
  await Supabase.initialize(anonKey: anonkey, url: url);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthGate());
  }
}
