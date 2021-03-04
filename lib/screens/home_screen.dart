import 'package:flutter/material.dart';
import 'package:pdf_reader/dialog/rename_file.dart';
import 'package:pdf_reader/model/file_operations.dart';
import 'package:pdf_reader/model/pdf_files.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf_reader/model/pdf_files_model.dart';
import 'package:pdf_reader/service/shared_service.dart';
import 'package:provider/provider.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_share/flutter_share.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future<List<PdfFiles>> _futureFiles;

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
    var pdfProvider = Provider.of<PdfFilesModel>(context, listen: true);

    if (operation == FileOperations.Favourite) {
      // Custom Toast Position

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

  Widget getFavouriteInrow(bool isFavourite) {
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
      debugPrint("${fileSnap.data[0].isFavourite}");
      return Consumer<PdfFilesModel>(
        builder: (context, pdffiles, child) {
          // var pdfProvider = Provider.of<PdfFilesModel>(context, listen: true);
          var files = pdffiles.allPdfFiles;
          return Container(
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                return ListTile(
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
                  leading: Icon(Icons.picture_as_pdf),
                  title: SizedBox(
                    child: Row(
                      children: [
                        Container(
                          width: 200,
                          // color: Colors.red,
                          child: Text(
                            files[index].name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        getFavouriteInrow(files[index].isFavourite)
                      ],
                    ),
                  ),
                  subtitle: Text(
                    '${files[index].lastModified} - ${files[index].size}',
                  ),
                  trailing: _buildTrailing(files[index], index),
                );
              },
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
  }

  @override
  Widget build(BuildContext context) {
    // return Consumer<PdfFilesModel>(
    //   builder: (context, model, widget) => FutureBuilder(
    //     future: model.getPdfFilesProvider(),
    //     builder: (BuildContext context, AsyncSnapshot<List<PdfFiles>> snap) {
    //       debugPrint('Future builder called aa');
    //       return _showFiles(snap);
    //     },
    //   ),
    // );
    var pdfProvider = Provider.of<PdfFilesModel>(
      context,
      listen: false,
    );

    return FutureBuilder(
      future: pdfProvider.getPdfFilesProvider(),
      builder: (context, AsyncSnapshot<List<PdfFiles>> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          print("future builder called ${asyncSnapshot.data.length}");
          return Consumer<PdfFilesModel>(
            builder: (context, pdffiles, child) {
              debugPrint("${pdffiles.allPdfFiles.length}");
              return _showFiles(asyncSnapshot);
            },
          );
        } else if (asyncSnapshot.hasError) {
          return Consumer<PdfFilesModel>(
            builder: (context, pdffiles, child) {
              return Container(
                child: Center(
                  child: Text('${asyncSnapshot.error}'),
                ),
              );
            },
          );
        } else {
          return Consumer<PdfFilesModel>(
            builder: (context, pdffiles, child) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }
      },
    );
  }
}
