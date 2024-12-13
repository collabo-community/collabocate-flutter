import 'package:flutter/material.dart';
import 'package:github_api_sync_app/repository/repo.dart';
import 'package:github_api_sync_app/reusables/constants.dart';
import 'package:github_api_sync_app/reusables/get_post_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> templates = [];
  String? selectedTemplateType;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  late RepoData repoData;
  bool isLoading = false;
  bool isTemplatesLoaded = false;

  @override
  void initState() {
    super.initState();
    repoData = RepoData();
    fetchTemplates();
  }

  // Function to fetch issue-temples from the backend.
  Future<void> fetchTemplates() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedTemplates = await repoData.fetchIssueTemplate();
      setState(() {
        templates = fetchedTemplates;
        isTemplatesLoaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load templates: $e'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Update issue body based on selected template
  void updateIssueBody(String? templateType) async {
    final template = templates.firstWhere(
      (template) => template['name'] == templateType,
      orElse: () => {'body': ''},
    );

    if (template['body'] != null) {
      final templateBody = await repoData.fetchTemplateBody(template['body']!);
      setState(() {
        selectedTemplateType = templateType;
        bodyController.text = templateBody;
      });
    }
  }

  // Function to create new issues using the RepoData class
  Future<void> createIssues() async {
    final title = titleController.text.trim();
    final body = bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide both title and body for the issue.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await repoData.createIssue(title, body);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Issue created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      titleController.clear();
      bodyController.clear();
      setState(() {
        selectedTemplateType = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      titleController.clear();
      bodyController.clear();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GitHub GET & POST Request',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose report type',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<String>(
                    icon: Icon(Icons.arrow_drop_down_circle_outlined),
                    value: selectedTemplateType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Template Type',
                    ),
                    items: templates.map((template) {
                      print('Template: ${template['name']}');
                      return DropdownMenuItem(
                        value: template['name'],
                        child: Text(template['name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) => updateIssueBody(value),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: titleController,
                decoration: kTextFormFieldDecoration.copyWith(
                  labelText: 'Issue Title',
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: bodyController,
                decoration: kTextFormFieldDecoration.copyWith(
                  labelText: 'Issue Body',
                ),
                maxLines: 5,
              ),
              SizedBox(
                height: 10,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : GetPostButton(
                      onPressed: () async {
                        await createIssues();
                      },
                      buttonText: 'POST ISSUE',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
