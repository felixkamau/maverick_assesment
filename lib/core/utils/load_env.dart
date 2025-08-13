import 'package:flutter_dotenv/flutter_dotenv.dart';
/*
  - Util function to load env variables
 */

Future<void> loadEnv() async {
  await dotenv.load(fileName: '.env');
}