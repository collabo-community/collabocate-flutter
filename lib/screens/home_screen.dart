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

  late RepoData repoData;

  @override
  void initState() {
    super.initState();
  }

  // Function to fetch issues with the RepoData class
  Future<void> fetchIssues() async {
    String owner = ownerController.text;
    String name = nameController.text;

    if (owner.isNotEmpty && name.isNotEmpty) {
      repoData = RepoData(owner, name);
      try {
        final fetchedIssues = await repoData.fetchIssues();
        setState(() {
          issues = fetchedIssues;
        });
        // Clearing text fields after fetching issues
        titleController.clear();
        bodyController.clear();
      } catch (e) {
        throw Exception(
          'Failed to load issues',
        );
      }
    }
  }

  // Function to create new issues using the RepoData class
  Future<void> createIssues() async {
    final title = titleController.text;
    final body = bodyController.text;

    if (title.isNotEmpty && body.isNotEmpty) {
      try {
        await repoData.createIssue(title, body);
        await fetchIssues();
        // Clearing text fields after fetching issues
        titleController.clear();
        bodyController.clear();
      } catch (e) {
        throw Exception('Failed to create issues');
      }
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
                height: 10,
              ),
              GetPostButton(
                onPressed: fetchIssues,
                buttonText: 'GET ISSUES',
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  if (issues.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          'Fetched Issues:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: issues.length,
                            itemBuilder: (context, index) {
                              final issue = issues[index];
                              return ListTile(
                                title: Text(
                                  issue['title'],
                                ),
                                leading: Icon(
                                  Icons.bug_report,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'No issues fetched yet.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                ],
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
              GetPostButton(
                onPressed: createIssues,
                buttonText: 'POST ISSUE',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
