import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get backendUrl => dotenv.env['BACKEND_URL'] ?? '';
}
