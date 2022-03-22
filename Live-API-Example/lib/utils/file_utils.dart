
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {

  static Future<Directory?> getLogDirectory() async {
    Directory? logDir;
    var logDirPath = "";
    if (Platform.isIOS) {
      logDirPath = (await getApplicationDocumentsDirectory()).path + "/log";
    }
    if (Platform.isAndroid) {
      var fileDir = (await getExternalStorageDirectories())?.first.path;
      if (fileDir != null && fileDir.isNotEmpty) {
        logDirPath = fileDir + "/log/liteav";
      }
    }
    if (logDirPath.isEmpty) {
      return logDir;
    }
    debugPrint("logDir: $logDirPath");
    logDir = Directory(logDirPath);
    return logDir;
  }

  static Future<List<File>?> getLogFiles() async {
    var logDirFiles = (await getLogDirectory())?.listSync();
    if (logDirFiles != null && logDirFiles.isNotEmpty) {
      List<File> logFiles = [];
      for (var element in logDirFiles) {
        if (element.path.endsWith("xlog")) {
          var file = File(element.path);
          logFiles.add(file);
        }
      }
      return logFiles;
    }
    return null;
  }

}