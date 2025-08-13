import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseInstanceClient = Supabase.instance.client;

Future<void> supabaseInitialisation(String anonKey, String url) async {
  await Supabase.initialize(url: url, anonKey: anonKey);
}
