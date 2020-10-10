import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

abstract class StaticMethods {
  static String applicationDocumentDirectory;

  static Future<bool> fileDownloadListener(String taskID) async {
    bool idFound = false;
    const int downloadTimeoutSeconds = 30;

    List<DownloadTask> loadTasks = await FlutterDownloader.loadTasks();
    for(int i = 0; i<downloadTimeoutSeconds*2; i++) {
      for (DownloadTask task in loadTasks) {
        if (task.taskId == taskID) {
          idFound = true;
          if (task.status == DownloadTaskStatus(3)) {
            return true;
          } else if (task.status == DownloadTaskStatus(4)) {
            return false;
          }
          break;
        }
      }
      await Future.delayed(Duration(milliseconds: 500));
      loadTasks = await FlutterDownloader.loadTasks();
    }

    if (!idFound) throw('Task ID not found: $taskID | loadTasks length: ${loadTasks.length}');
    else {
      FlutterDownloader.cancel(taskId: taskID);
      return false;
    }
  }


  static Future<bool> detectDownloadedFile(String url) async {
    String dirPath = '${(await getApplicationDocumentsDirectory()).path}/kktca/';
    await checkFolderAndCreate('kktca');
    await for (FileSystemEntity value in Directory(dirPath).list()) {
      if (url.substring(url.lastIndexOf('/')) ==
          value.path.substring(value.path.lastIndexOf('/'))) {
        return true;
      }
    }
    return false;
  }

  static Future<void> checkFolderAndCreate(String folderName) async {
    final path = Directory("${(await getApplicationDocumentsDirectory()).path}/$folderName/");
    if (await path.exists()) {
    } else {
      await path.create();
    }
  }

  static Future<String> savePdfToStorage(String url) async {
    await checkFolderAndCreate('kktca');
    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: '${(await getApplicationDocumentsDirectory()).path}/kktca/',
      fileName: url.substring(url.lastIndexOf("/") + 1),
      showNotification: false, // show download progress in status bar (for Android)
      openFileFromNotification: false, // click on notification to open downloaded file (for Android)
    );
  }

  static Future<String> savePdfToTmp(String url) async {
    await checkFolderAndCreate('tmp');
    return await FlutterDownloader.enqueue(
    url: url,
    savedDir: '${(await getApplicationDocumentsDirectory()).path}/tmp/',
    fileName: 'tmpFile.pdf',
    showNotification: false, // show download progress in status bar (for Android)
    openFileFromNotification: false, // click on notification to open downloaded file (for Android)
    );
  }

  static Future<bool> deleteFileFromStorage(String path) async {
    File file = File(path);
    await file.delete();
    return false;
  }

  static Future<String> readListTilesDataFromStorage() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      String path = dir.path + '/list_tiles_data.csv';
      var dataFile = File(path);
      if (!await dataFile.exists()) await dataFile.create();
      String dataString = await dataFile.readAsString();
      return dataString;
    } on FileSystemException catch(e) {
      return null;
    }
  }

  static Future<void> writeListTilesDataToStorage(String data) async {
    final dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/list_tiles_data.csv';
    var dataFile = File(path);
    await dataFile.writeAsString(data);
  }

  static void showDownloadFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('İndirme Başarısız Oldu'),
          content: Text('İnternet bağlantınızı kontrol edin'),
          actions: <Widget>[
            FlatButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  static void showDownloadingDialog(BuildContext context, String title) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text('Cevap anahtarı indirildikten sonra açılacak'),
          );
        }
    );
  }
}