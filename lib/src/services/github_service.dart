import 'dart:convert';

import 'package:collabocate/src/config/config.dart';
import 'package:collabocate/src/models/template_model.dart';
import 'package:http/http.dart' as http;

class GitHubService {
  final String baseUrl = AppConfig.backendUrl;

  Future<List<IssueTemplate>> fetchIssueTemplates() async {
    final url = Uri.parse(
      '$baseUrl/external/github/issue-templates',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse is! Map ||
            !decodedResponse.containsKey('templates')) {
          throw Exception(
            'Invalid API response format.',
          );
        }

        if (decodedResponse['templates'] is List) {
          return (decodedResponse['templates'] as List)
              .map(
                (template) => IssueTemplate.fromJson(template),
              )
              .toList();
        }
      }
      throw Exception(
        'Failed to load templates: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(
        'Error fetching templates: $e',
      );
    }
  }

  Future<String> fetchTemplateBody(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        return response.body;
      }
      throw Exception(
        'Failed to fetch template body.',
      );
    } catch (e) {
      throw Exception(
        'Error fetching template body: $e',
      );
    }
  }

  Future<void> createIssue(String title, String body) async {
    final url = Uri.parse(
      '$baseUrl/external/github/issues',
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
        throw Exception(
          'Failed to create issue: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
