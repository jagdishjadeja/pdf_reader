import 'package:flutter/material.dart';
import 'package:pdf_reader/model/pdf_files.dart';
import "package:collection/collection.dart";
import 'package:pdf_reader/model/sort_by.dart';
import 'package:pdf_reader/model/sort_order.dart';

class PdfFilesModel extends ChangeNotifier {
  var _pdfFiles = List<PdfFiles>();
  var _tempBool = false;

  Future<List<PdfFiles>> _futureFiles;

  SortBy sortBy = SortBy.NONE;
  SortOrder sortOrder = SortOrder.NONE;

  initData() {}

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
    // PdfFiles.
    var tempFiles = await getAllPdfFiles();
    _pdfFiles = tempFiles;

    return _pdfFiles;
  }

  void sortFiles(SortBy sortBy) {
    if (sortBy == SortBy.Name) {
      _pdfFiles.sort((a, b) => compareAsciiUpperCase(a.name, b.name));
    } else if (sortBy == SortBy.Size) {
      _pdfFiles.sort((a, b) => compareAsciiUpperCase(a.size, b.size));
    } else if (sortBy == SortBy.Date) {
      _pdfFiles.sort(
          (a, b) => compareAsciiUpperCase(a.lastModified, b.lastModified));
    }
    debugPrint('Sorted By $sortBy');
    notifyListeners();
  }
}
