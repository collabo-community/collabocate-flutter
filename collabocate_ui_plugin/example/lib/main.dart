import 'package:collabocate_ui_plugin/collabocate_ui_plugin.dart';
import 'package:example/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CollabocateUI collabocateUI;

  @override
  void initState() {
    super.initState();
    _initializeCollabocateUI();
  }

  void _initializeCollabocateUI() {
    collabocateUI = CollabocateUI(
      backendUrl: AppConfig.backendUrl,
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    _initializeCollabocateUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collabocate UI Plug'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          IssueForm(
            githubService: collabocateUI.githubService,
            buttonStyle: ElevatedButton.styleFrom(
              minimumSize: Size(
                double.infinity,
                50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
