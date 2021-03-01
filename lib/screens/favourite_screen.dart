import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf_reader/model/pdf_files.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  Future<List<PdfFiles>> _futureFiles;

  Widget _showFiles(AsyncSnapshot<List<PdfFiles>> fileSnap) {
    if (fileSnap.hasData) {
      var files = fileSnap.data;

      return Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text(files[index].name),
              subtitle: Text(''),
              trailing: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  setState(() {});
                },
              ),
            );
          },
          itemCount: files.length,
        ),
      );
    } else if (fileSnap.hasError) {
      print(fileSnap.error);
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
    _futureFiles = getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureFiles,
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
