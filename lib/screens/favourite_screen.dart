import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf_reader/dialog/rename_file.dart';
import 'package:pdf_reader/model/file_operations.dart';
import 'package:pdf_reader/model/pdf_files.dart';
import 'package:pdf_reader/model/pdf_files_model.dart';
import 'package:pdf_reader/service/shared_service.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  // Future<List<PdfFiles>> _futureFiles;

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

  Future<PdfFiles> fileOperations(
    FileOperations operation,
    PdfFiles file,
  ) async {
    if (operation == FileOperations.Favourite) {
      if (file.isFavourite) {
        await SharedService.removeFromFavourite(file.file.path);
        showToast('Removed From Favourite');
      } else {
        await SharedService.addToFavourite(file.file.path);
        showToast('Added to favourite');
      }
      file.isFavourite = !file.isFavourite;
      return file;
    } else if (operation == FileOperations.Share) {
      await FlutterShare.shareFile(
        title: 'Example share',
        text: 'Example share text',
        filePath: file.file.path,
      );

      return file;
    } else if (operation == FileOperations.Rename) {
      var newFileName = await showDialog<String>(
        context: context,
        builder: (context) => RenameDialog(
          fileName: file.name,
        ),
      );
      if (newFileName != null) {
        var newFilePath = file.filePath + '/' + newFileName + '.pdf';
        file.name = newFileName;
        file.file = await file.file.rename(newFilePath);
      }
      return file;
    } else if (operation == FileOperations.Delete) {
      var tempFile = file;
      await tempFile.file.delete();
      showToast('${file.name} file deleted');
      return file;
    } else {
      return file;
    }
  }

  Widget _buildTrailing(PdfFiles file, int index) {
    var pdfProvider = Provider.of<PdfFilesModel>(context, listen: true);

    return PopupMenuButton(
      onSelected: (FileOperations operation) async {
        debugPrint('favourite - ${file.isFavourite}');
        var tempFile = await fileOperations(operation, file);
        if (operation == FileOperations.Favourite) {
          pdfProvider.updateArray(index, tempFile.isFavourite);
        } else if (operation == FileOperations.Share) {
        } else if (operation == FileOperations.Rename) {
          file = tempFile;
        } else if (operation == FileOperations.Delete) {
          pdfProvider.deleteFile(index);
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Row(
              children: [
                getFavourite(file.isFavourite),
                SizedBox(width: 10),
                Text('Favourite'),
              ],
            ),
            value: FileOperations.Favourite,
          ),
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.share),
                SizedBox(width: 10),
                Text('Share'),
              ],
            ),
            value: FileOperations.Share,
          ),
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 10),
                Text('Rename'),
              ],
            ),
            value: FileOperations.Rename,
          ),
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.delete),
                SizedBox(width: 10),
                Text('Delete'),
              ],
            ),
            value: FileOperations.Delete,
          ),
        ];
      },
    );
  }

  Widget _showFiles(AsyncSnapshot<List<PdfFiles>> fileSnap) {
    if (fileSnap.hasData) {
      var files = fileSnap.data;

      if (fileSnap.data.length > 0)
        return Container(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text(files[index].name),
                subtitle: Text(''),
                trailing: _buildTrailing(files[index], index),
                onTap: () async {
                  PDFDocument doc =
                      await PDFDocument.fromFile(files[index].file);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PDFViewer(
                          document: doc,
                          zoomSteps: 1,
                        );
                      },
                    ),
                  );
                },
              );
            },
            itemCount: files.length,
          ),
        );
      return Center(
        child: Text('No favourites found'),
      );
    } else if (fileSnap.hasError) {
      return Text('Error : ${fileSnap.error}');
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // _futureFiles = getFiles();
  }

  @override
  Widget build(BuildContext context) {
    var pdfProvider = Provider.of<PdfFilesModel>(
      context,
      listen: false,
    );
    return FutureBuilder(
      future: pdfProvider.getFavoruiteFiles(),
      builder: (BuildContext context, AsyncSnapshot<List<PdfFiles>> snap) {
        if (snap.connectionState == ConnectionState.done) {
          return _showFiles(snap);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
