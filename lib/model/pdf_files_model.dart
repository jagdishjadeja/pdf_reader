import 'package:flutter/material.dart';
import 'package:pdf_reader/model/pdf_files.dart';
import "package:collection/collection.dart";
import 'package:pdf_reader/model/sort_by.dart';
import 'package:pdf_reader/model/sort_order.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfFilesModel extends ChangeNotifier {
  var _pdfFiles = <PdfFiles>[];
  var _favPdfFiles = <PdfFiles>[];
  var _tempBool = false;

  Future<List<PdfFiles>> _futureFiles;

  SortBy sortBy = SortBy.NONE;
  SortOrder sortOrder = SortOrder.NONE;

  initData() {}

  void updateArray(int index, bool isFavourite) {
    _pdfFiles[index].isFavourite = isFavourite;
    notifyListeners();
  }

  void deleteFile(index) {
    _pdfFiles.removeAt(index);
    notifyListeners();
  }

  List<PdfFiles> getPdfFiles() {
    return _pdfFiles;
  }

  Future<List<PdfFiles>> get getFutureFiles {
    // _futureFiles = getFiles();
    return _futureFiles;
  }

  List<PdfFiles> get allPdfFiles {
    return _pdfFiles;
  }

  bool get boolValue {
    return _tempBool;
  }

  void toggleBool() {
    _tempBool = !_tempBool;
    _futureFiles = getFiles();
    notifyListeners();
  }

  Future<List<PdfFiles>> getPdfFilesProvider() async {
    var permission = await Permission.storage.request().isGranted;
    if (permission) {
      var tempFiles = await getAllPdfFiles();
      _pdfFiles = tempFiles;
    }
    return _pdfFiles;
  }

  Future<List<PdfFiles>> getFavoruiteFiles() async {
    var tempFiles = await getFavouritePdfFiles();
    _favPdfFiles = tempFiles;
    return _favPdfFiles;
  }

  void sortFiles(SortBy sortBy) {
    if (sortBy == SortBy.Name) {
      _pdfFiles.sort((a, b) => compareAsciiUpperCase(a.name, b.name));
    } else if (sortBy == SortBy.Size) {
      _pdfFiles.sort((a, b) => compareAsciiUpperCase(a.size, b.size));
    } else if (sortBy == SortBy.Date) {
      _pdfFiles.sort(
        (a, b) => compareAsciiUpperCase(a.lastModified, b.lastModified),
      );
    }
    notifyListeners();
    debugPrint('Sorted By $sortBy');
  }

  void renameFile(index, file) {}

  void toggleFavourite(index) {}

  void share() {}
}
