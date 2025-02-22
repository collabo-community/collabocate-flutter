# @collabo-community/collabocate (flutter)

V1.0.0 development in progress. Contributions welcome. Learn how you can contribute to the project: [resources.collabo.community](https://resources.collabo.community)

#

### Contributors
[![All Contributors](https://img.shields.io/github/all-contributors/collabo-community/collabocate-flutter?color=ee8449&style=flat-square)](#contributors) [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://docs.collabocommunity.com/projects-overview) [![License: AGPL v3.0](https://img.shields.io/badge/License-AGPL%20v3.0-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/Ifycode"><img src="https://avatars.githubusercontent.com/u/45185388?v=4?s=100" width="100px;" alt="Mary @Ifycode"/><br /><sub><b>Mary @Ifycode</b></sub></a><br /><a href="https://github.com/collabo-community/collabocate-flutter/commits?author=Ifycode" title="Code">💻</a></td>
      <td align="center" valign="top" width="16.66%"><a href="https://github.com/Oyebliss"><img src="https://avatars.githubusercontent.com/u/148455956?v=4?s=100" width="100px;" alt="Olatunji Sodiq Oyebisi "/><br /><sub><b>Olatunji Sodiq Oyebisi </b></sub></a><br /><a href="https://github.com/collabo-community/collabocate-flutter/commits?author=Oyebliss" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->


# collabocate_Flutter(plugin)
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
  collabocate_flutter:
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

## Basic usage
```dart
import 'package:collabocate_flutter/collabocate.dart';
import 'package:flutter/material.dart';

void main()  {
  runApp(const MyApp());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CollabocateFlutter(),
    );
  }
}
```

## Example
View the flutter app in the `example(collabocate_flutter_test_app)` directory.
