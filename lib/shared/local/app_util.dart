import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppUtil {
  static Future<String> createFolderInAppDocDir(String folderName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory appDocDirFolder =
        Directory('${appDocDir.path}/$folderName/');

    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  var path = "storage/emulated/0/NewsApp";
  void intilaizePath() async {
    Directory dir = Directory(path);
    if (await dir.exists() == false) {
      await dir.create(recursive: true);
    }
  }
}
