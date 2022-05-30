import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:path/path.dart';

class PanelView extends StatelessWidget {
  PanelView(this.path, {Key? key}) : super(key: key);
  final Directory path;
  @override
  Widget build(BuildContext context) {
    final files = path
        .listSync()
        .map((e) => Dirr(path: e.path, type: FileSystemEntity.typeSync(e.path)))
        .toList();
    files.sort((x, y) => x.path.compareTo(y.path));

    files.sort((x, y) => x.type == y.type ? 0 : 1);
    return Material(
      child: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return InkWell(
            // dense: true,
            onTap: () {
              // c.setPath(0, file.path);
            },
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  child: Icon(
                    file.type == FileSystemEntityType.directory
                        ? CupertinoIcons.folder_fill
                        : CupertinoIcons.doc,
                    size: 14,
                    color: file.type == FileSystemEntityType.directory
                        ? Colors.yellow
                        : Colors.white,
                  ),
                ),
                Text(basename(file.path)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Dirr {
  String path;
  FileSystemEntityType type;
  Dirr({
    required this.path,
    required this.type,
  });
}
