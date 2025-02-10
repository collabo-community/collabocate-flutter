import 'package:collabocate_ui_plugin/src/models/template_model.dart';
import 'package:collabocate_ui_plugin/src/services/github_service.dart';
import 'package:flutter/material.dart';

class IssueForm extends StatefulWidget {
  final GitHubService githubService;
  final TextStyle? labelStyle;
  final InputDecoration? inputDecoration;
  final ButtonStyle? buttonStyle;

  const IssueForm({
    super.key,
    required this.githubService,
    this.labelStyle,
    this.inputDecoration,
    this.buttonStyle,
  });

  @override
  State<IssueForm> createState() => _IssueFormState();
}

class _IssueFormState extends State<IssueForm> {
  List<IssueTemplate> templates = [];
  String? selectedTemplateType;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTemplates();
  }

  Future<void> _fetchTemplates() async {
    setState(
      () => isLoading = true,
    );
    try {
      final fetchedTemplates = await widget.githubService.fetchIssueTemplates();
      setState(
        () => templates = fetchedTemplates,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load templates: $e'),
        ),
      );
    } finally {
      setState(
        () => isLoading = false,
      );
    }
  }

  Future<void> _updateIssueBody(String? templateType) async {
    final template = templates.firstWhere(
      (template) => template.name == templateType,
      orElse: () => IssueTemplate(
        name: '',
        downloadUrl: '',
      ),
    );

    if (template.downloadUrl.isNotEmpty) {
      final templateBody = await widget.githubService.fetchTemplateBody(
        template.downloadUrl,
      );
      setState(
        () {
          selectedTemplateType = templateType;
          bodyController.text = templateBody;
        },
      );
    }
  }

  Future<void> _createIssue() async {
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
      await widget.githubService.createIssue(title, body);
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
      setState(() => selectedTemplateType = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultInputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose report type',
            style: widget.labelStyle ?? const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            value: selectedTemplateType,
            decoration: (widget.inputDecoration ?? defaultInputDecoration)
                .copyWith(labelText: 'Template Type'),
            items: templates.map((template) {
              return DropdownMenuItem(
                value: template.name,
                child: Text(template.name),
              );
            }).toList(),
            onChanged: (value) => _updateIssueBody(value),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: titleController,
            decoration: (widget.inputDecoration ?? defaultInputDecoration)
                .copyWith(labelText: 'Issue Title'),
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: bodyController,
            decoration: (widget.inputDecoration ?? defaultInputDecoration)
                .copyWith(labelText: 'Issue Body'),
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: widget.buttonStyle,
                    onPressed: _createIssue,
                    child: const Text('POST ISSUE'),
                  ),
          ),
        ],
      ),
    );
  }
}
