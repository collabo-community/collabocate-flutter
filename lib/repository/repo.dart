import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RepoData {
  String backendURL = dotenv.env['BACKEND_URL'] ?? '';

// Function to perform a GET request to fetch issue-templates from a Github repo.
  Future<List<Map<String, String>>> fetchIssueTemplate() async {
    final url = Uri.parse('$backendURL/github/issue-templates');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['templates'] is List) {
          return (decodedResponse['templates'] as List).map((template) {
            return {
              'name': template['name'] as String,
              'body': template['download_url'] as String, // Link to fetch body
            };
          }).toList();
        } else {
          throw Exception('Unexpected response format.');
        }
      } else {
        throw Exception(
            'Failed to load templates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching templates: $e');
    }
  }

  // Function to fetch a template body
  Future<String> fetchTemplateBody(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to fetch template body.');
      }
    } catch (e) {
      throw Exception('Error fetching template body: $e');
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
