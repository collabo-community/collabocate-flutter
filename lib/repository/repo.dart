import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RepoData {
  String backendURL = dotenv.env['BACKEND_URL'] ?? '';

// Function to perform a GET request to fetch issues from a Github repo.
  Future<List<dynamic>> fetchIssues() async {
    final url = Uri.parse(
      '$backendURL/github/issues',
    );

    try {
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception(
            'Repository not found. Please check the owner and repository name.');
      } else {
        throw ('Failed to fetch issues.');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Function to create an new issue using a POST request
  Future<void> createIssue(String title, String body) async {
    final url = Uri.parse(
      '$backendURL/github/issues',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'body': body,
        }),
      );
      if (response.statusCode != 201) {
        throw ('Failed to create issue: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
