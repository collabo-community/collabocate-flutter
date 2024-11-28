import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RepoData {
  // Repository Details
  String repositoryOwner;
  String repositoryName;
  String githubToken = dotenv.env['GITHUB_TOKEN'] ?? '';

  RepoData(this.repositoryOwner, this.repositoryName);

// Function to perform a GET request to fetch issues from a Github repo.
  Future<List<dynamic>> fetchIssues() async {
    final url = Uri.https(
        'api.github.com', '/repos/$repositoryOwner/$repositoryName/issues');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $githubToken',
        'Accept': 'application/vnd.github.v3+json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load issues');
    }
  }

  // Function to create an new issue using a POST request
  Future<void> createIssue(String title, String body) async {
    final url = Uri.https(
        'api.github.com', '/repos/$repositoryOwner/$repositoryName/issues');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $githubToken',
        'Accept': 'application/vnd.github.v3+json',
      },
      body: jsonEncode(
        {
          'title': title,
          'body': body,
        },
      ),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create issue');
    }
  }
}
