import 'package:file_manager/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Application",
      // initialRoute: AppPages.initial,
      home: HomePage(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      // getPages: AppPages.routes,
    ),
  );
}
