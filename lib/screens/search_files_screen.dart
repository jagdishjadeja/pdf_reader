import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/pdf_files.dart';

class SearchFilesScreen extends SearchDelegate {
  final List<PdfFiles> filesList;

  SearchFilesScreen({this.filesList});

  Widget _buildResult(String query) {
    var result = filesList.where((x) => x.name.contains(query)).toList();
    if (result.length > 0) {
      return ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              PDFDocument doc = await PDFDocument.fromFile(result[index].file);
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
            leading: Text(result[index].name),
          );
        },
      );
    } else {
      return Center(
        child: Text('File not found'),
      );
    }
  }

  // Widget _suggestion() {}

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }
    return _buildResult(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResult(query);
  }
}
