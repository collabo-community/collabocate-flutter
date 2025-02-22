library collabocate_ui_plugin;

import 'package:collabocate/src/config/config.dart';
import 'package:collabocate/src/models/template_model.dart';
import 'package:collabocate/src/services/github_service.dart';
import 'package:flutter/material.dart';

class Collabocate extends StatefulWidget {
  const Collabocate({super.key});

  @override
  State<Collabocate> createState() => _CollabocateState();
}

class _CollabocateState extends State<Collabocate> {
  //late final GitHubService _service = GitHubService();
  GitHubService? _service;
  List<IssueTemplate> templates = [];
  String? selectedTemplateType;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool isLoading = false;
  bool isInitialized = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeConfig();
  }

  Future<void> _initializeConfig() async {
    try {
      await AppConfig.initialize();
      setState(() {
        _service = GitHubService();
        isInitialized = true;
      });
      await _fetchTemplates();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _fetchTemplates() async {
    if (_service == null) return;

    setState(() => isLoading = true);
    try {
      templates = await _service!.fetchIssueTemplates();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load templates: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateIssueBody(String? templateType) async {
    if (_service == null || templateType == null) return;

    setState(() => isLoading = true);
    try {
      final template = templates.firstWhere(
        (template) => template.name == templateType,
        orElse: () => IssueTemplate(
          name: '',
          downloadUrl: '',
        ),
      );
      final templateBody =
          await _service!.fetchTemplateBody(template.downloadUrl);
      setState(() {
        selectedTemplateType = templateType;
        bodyController.text = templateBody;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load template: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(
        () => isLoading = false,
      );
    }
  }

  Future<void> _createIssue() async {
    if (_service == null) return;

    final title = titleController.text.trim();
    final body = bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please provide both title and body for the issue.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(
      () => isLoading = true,
    );
    try {
      await _service!.createIssue(title, body);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Issue created successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      titleController.clear();
      bodyController.clear();
      setState(() {
        selectedTemplateType = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(
        () => isLoading = false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Configuration Error: $errorMessage\nPlease ensure .env file exists with BACKEND_URL.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }

    if (!isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collabocate Flutter'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose report type',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedTemplateType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                labelText: 'Template Type',
              ),
              items: templates.map((template) {
                return DropdownMenuItem(
                  value: template.name,
                  child: Text(
                    template.name,
                  ),
                );
              }).toList(),
              onChanged: (value) => _updateIssueBody(value),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: 'Issue Title',
              ),
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: bodyController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: 'Issue Body',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: isLoading ? null : _createIssue,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Create Issue',
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
