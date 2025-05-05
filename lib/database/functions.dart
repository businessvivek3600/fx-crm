/// FileStorge

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileStorage {
  static Future<String?> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        // If not we will ask for permission first
        await Permission.storage.request();
      }
      Directory _directory = Directory("");
      if (Platform.isAndroid) {
        // Redirects it to download folder in android
        _directory = Directory("/storage/emulated/0/Download");
      } else {
        _directory = await getApplicationDocumentsDirectory();
      }

      final exPath = _directory.path;
      print("Saved Path: $exPath");
      await Directory(exPath).create(recursive: true);
      return exPath;
    } catch (e) {
      // print("Error getting external document path: $e");
      return null;
    }
  }

  static Future<void> saveFile(File file, String path) async {
    File newFile = await file.copy(path);
    // print("File saved to: ${newFile.path}");
    await newFile.create(recursive: true);
    // print("File created: ${newFile.path}");
    newFile.writeAsStringSync(file.readAsStringSync());
  }

  static Future<String?> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String? directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(String bytes, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name');
    ;
    // print("Save file");

    // Write the data in the file you have created
    return file.writeAsString(bytes);
  }
}
