import 'package:collabocate_ui_plugin/src/services/github_service.dart';

class CollabocateUI {
  final String backendUrl;

  CollabocateUI({required this.backendUrl});

  GitHubService get githubService => GitHubService(
        backendUrl: backendUrl,
      );
}
