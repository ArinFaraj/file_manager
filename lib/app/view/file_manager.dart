import 'package:file_manager/home/home.dart';
import 'package:flutter/material.dart';

class FileManager extends StatelessWidget {
  const FileManager({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Application",
      home: const HomePage(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
    );
  }
}
