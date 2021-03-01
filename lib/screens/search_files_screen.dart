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

  Widget _suggestion() {}

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
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
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
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
    print(query);

    return _buildResult(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    print(query);

    return _buildResult(query);
  }
}
