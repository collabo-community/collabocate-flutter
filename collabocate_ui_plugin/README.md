# collabocate_ui_plugin
A Flutter plugin that provides a customizable GitHub issue management interface. This plugin allows users to create GitHub issues using predefined templates with a clean, modern UI.

## Features
- GitHub issues submission
- Customizable UI components
- GitHub issue template support
- Real-time template loading
- Environment-based configuration

## Getting started
## Installation
To use this plugin, Add this to your package's `pubspec.yaml` file:
```dart
dependencies:
  collabocate_ui_plugin:
    git:
      url: https://github.com/yourusername/collabocate_ui_plugin.git
```

## Usage
## Environment Setup
1. Create a .env file in your project root and add:
```dart
BACKEND_URL=your_backend_url_here
```
get idea from `.env.example` in the example folder

2. Add .env to your pubspec.yaml:
 ```dart
flutter:
  assets:
    - .env
```
3. Create a configuration file just as in the example folder and add:
 ```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get backendUrl => dotenv.env['BACKEND_URL'] ?? '';
}
```
This is to configure your set abd get your backendurl from the `.env` file

## Basic usage
```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:collabocate_ui_plugin/collabocate_ui_plugin.dart';
import 'config/app_config.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); //Load your backendUrl from `.env` file.
  runApp(const MyApp());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CollabocateUI collabocateUI; // Creating an instance for the initialization of the API server from Collabocate plugin

  @override
  void initState() {
    super.initState();
    _initializeCollabocateUI();
  }

  void _initializeCollabocateUI() {
    collabocateUI = CollabocateUI(
      backendUrl: AppConfig.backendUrl, // setting the backendurl in the instance
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IssueForm(
        githubService: collabocateUI.githubService, 
      ), // Issue form is the widget for displaying the issues creation form
    );
  }
}
```


## Additional information
## CollabocateUI
This is the Main class for initializing the plugin.
```dart
CollabocateUI({required String backendUrl})
```
## IssueForm
This is the Widget for displaying the issue creation form.
```dart
IssueForm({
  required GitHubService githubService,
  TextStyle? labelStyle,
  InputDecoration? inputDecoration,
  ButtonStyle? buttonStyle,
})
```
## Example
View the flutter app in the `example` directory
