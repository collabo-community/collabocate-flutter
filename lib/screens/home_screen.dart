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
  TextEditingController ownerController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  RepoData? repoData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Adding listeners for text controllers
    ownerController.addListener(() => setState(() {}));
    nameController.addListener(() => setState(() {}));
  }

  // Function to fetch issues with the RepoData class
  Future<void> fetchIssues() async {
    String owner = ownerController.text;
    String name = nameController.text;

    if (owner.isNotEmpty && name.isNotEmpty) {
      repoData = RepoData(owner, name);
      try {
        final fetchedIssues = await repoData!.fetchIssues();
        setState(() {
          issues = fetchedIssues;
        });
        // Clearing text fields after fetching issues
        titleController.clear();
        bodyController.clear();
      } catch (e) {
        if (!mounted) return;
        // Displaying error message on the screen using ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error in either owner or repo name: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Inform the user to provide owner and repo name if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both owner and repository name.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to create new issues using the RepoData class
  Future<void> createIssues() async {
    final title = titleController.text;
    final body = bodyController.text;

    // Ensure repoData is initialized
    repoData ??= RepoData(ownerController.text, nameController.text);

    if (title.isNotEmpty && body.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        await repoData!.createIssue(title, body);
        await fetchIssues();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Issue created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Clearing text fields after fetching issues
        titleController.clear();
        bodyController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create issue: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide both title and body for the issue.'),
          backgroundColor: Colors.red,
        ),
      );
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
                controller: ownerController,
                decoration: kTextFormFieldDecoration.copyWith(
                  labelText: 'Repository Owner',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: nameController,
                decoration: kTextFormFieldDecoration.copyWith(
                  labelText: 'Repository Name',
                ),
              ),
              SizedBox(
                height: 25,
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
                maxLines: 3,
              ),
              SizedBox(
                height: 10,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : GetPostButton(
                      onPressed: (ownerController.text.isNotEmpty &&
                              nameController.text.isNotEmpty)
                          ? () async {
                              await createIssues();
                            }
                          : null,
                      buttonText: 'POST ISSUE',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
