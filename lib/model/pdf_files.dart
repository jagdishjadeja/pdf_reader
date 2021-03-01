import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:intl/intl.dart';

PdfFiles pdfFilesFromJson(String str) => PdfFiles.fromJson(json.decode(str));

String pdfFilesToJson(PdfFiles data) => json.encode(data.toJson());

Future<List<PdfFiles>> getPdfFiles(FileManager fm) async {
  var files = await fm.filesTree(
    excludedPaths: ["/storage/emulated/0/Android"],
    extensions: ["pdf"],
  );

  var pdfFile = files.map((File file) {
    final DateFormat formatter = DateFormat('MMM-yy-dd');
    var fileName = file.path.split('/').last.split('.')[0];
    var tempfilePath = file.path.split('/');
    tempfilePath.removeLast();
    var filePath = tempfilePath.join('/');
    var pdfFile = PdfFiles(
      isFavourite: false,
      lastModified: formatter.format(file.lastModifiedSync()),
      name: fileName,
      size: (file.lengthSync() / 1024).toStringAsFixed(2) + ' KB',
      filePath: filePath,
      file: file,
    );
    return pdfFile;
  }).toList();

  return pdfFile;
}

Future<List<PdfFiles>> getFiles() async {
  List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
  var root = storageInfo[0].rootDir;
  var fm = FileManager(root: Directory(root)); //
  return compute(getPdfFiles, fm);
}

Future<List<PdfFiles>> getAllPdfFiles() async {
  List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
  var root = storageInfo[0].rootDir;
  var fm = FileManager(root: Directory(root)); //
  var files = await compute(getPdfFiles, fm);
  return files;
}

class PdfFiles {
  PdfFiles(
      {this.name,
      this.size,
      this.isFavourite,
      this.lastModified,
      this.filePath,
      this.dirname,
      this.file});

  String name;
  String size;
  bool isFavourite;
  String lastModified;
  String filePath;
  String dirname;
  File file;

  factory PdfFiles.fromJson(Map<String, dynamic> json) => PdfFiles(
        name: json["name"],
        size: json["size"],
        isFavourite: json["isFavourite"],
        lastModified: json["lastModified"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "size": size,
        "isFavourite": isFavourite,
        "lastModified": lastModified,
      };
}
