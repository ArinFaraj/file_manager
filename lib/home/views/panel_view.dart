import 'dart:io';

import 'package:file_manager/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show basename;

class PanelView extends StatelessWidget {
  const PanelView(this.path, {Key? key}) : super(key: key);

  final Directory path;

  @override
  Widget build(BuildContext context) {
    final files = path
        .listSync()
        .map((e) => Dirr(path: e.path, type: FileSystemEntity.typeSync(e.path)))
        .toList();
    files.sort((x, y) => x.path.compareTo(y.path));
    files.sort((x, y) => x.type == y.type ? 0 : 1);
    files.insert(
        0,
        Dirr(
            path: (path.path.split(Platform.pathSeparator)..removeLast())
                .join(Platform.pathSeparator),
            overridenName: '../',
            type: FileSystemEntity.typeSync(path.path)));
    return Material(
      child: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return InkWell(
            // dense: true,
            onTap: () {
              context.read<HomeBloc>().add(
                    HomeSetPath(0, file.path),
                  );
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
                Text(file.overridenName ?? basename(file.path)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Dirr {
  Dirr({
    required this.path,
    this.overridenName,
    required this.type,
  });

  String? overridenName;
  String path;
  FileSystemEntityType type;
}
