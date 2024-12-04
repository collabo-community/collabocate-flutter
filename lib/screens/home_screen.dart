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
  List<dynamic> issues = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  late RepoData repoData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    repoData = RepoData();
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
                maxLines: 3,
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
