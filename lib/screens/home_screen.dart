import 'package:flutter/material.dart';
import 'package:pdf_reader/dialog/rename_file.dart';
import 'package:pdf_reader/model/pdf_files.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf_reader/model/pdf_files_model.dart';
import 'package:pdf_reader/service/shared_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<PdfFiles>> _futureFiles;

  void showToast(String message) {
    var fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black45,
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Future<PdfFiles> fileOperations(int operation, PdfFiles file) async {
    if (operation == 0) {
      // Custom Toast Position
      file.isFavourite = !file.isFavourite;

      if (file.isFavourite) {
        await SharedService.removeFromFavourite(file.filePath);
        showToast('Removed From Favourite');
      } else {
        SharedService.addToFavourite(file.filePath);
        showToast('Added to favourite');
      }
      return file;
    } else if (operation == 1) {
      return file;
    } else if (operation == 2) {
      var newFileName = await showDialog<String>(
        context: context,
        builder: (context) => RenameDialog(
          fileName: file.name,
        ),
      );
      var newFilePath = file.filePath + '/' + newFileName + '.pdf';
      file.name = newFileName;
      file.file = await file.file.rename(newFilePath);
      return file;
    } else if (operation == 3) {
      return file;
    } else if (operation == 4) {
      return file;
    } else {
      return file;
    }
  }

  Widget getFavouriteInrow(isFavourite) {
    if (isFavourite) {
      return Icon(
        Icons.star,
        color: Colors.blue,
        size: 20,
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Icon getFavourite(bool isFavourite, {bool isSmall = false}) {
    if (isFavourite) {
      return Icon(
        Icons.star,
        color: Colors.blue,
      );
    } else {
      return Icon(Icons.star_border);
    }
  }

  Widget _showFiles(AsyncSnapshot<List<PdfFiles>> fileSnap) {
    print(fileSnap.data);
    if (fileSnap.hasData) {
      print('here ${fileSnap.data.length}');
      var pdfProvider = Provider.of<PdfFilesModel>(context, listen: false);
      return Consumer<PdfFilesModel>(
        builder: (context, pdffiles, child) {
          return Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text(pdfProvider.allPdfFiles[index].name),
                  subtitle: Text(
                      '${pdfProvider.allPdfFiles[index].lastModified} - ${pdfProvider.allPdfFiles[index].size}'),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                );
              },
              itemCount: pdfProvider.getPdfFiles().length,
            ),
          );
        },
      );
    } else if (fileSnap.hasError) {
      return Center(
        child: Text('Error :${fileSnap.error}'),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _futureFiles = getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfFilesModel>(
      builder: (context, model, widget) => FutureBuilder(
        future: model.getPdfFilesProvider(),
        builder: (BuildContext context, AsyncSnapshot<List<PdfFiles>> snap) {
          return _showFiles(snap);
        },
      ),
    );
  }
}
