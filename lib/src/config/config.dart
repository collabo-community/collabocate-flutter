import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get backendUrl => dotenv.env['BACKEND_URL'] ?? '';

  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      throw Exception(
        'Failed to load environment variables. Please ensure .env file exists in your project root.',
      );
    }

    if (backendUrl.isEmpty) {
      throw Exception(
        'BACKEND_URL not found in environment variables',
      );
    }
  }
}
