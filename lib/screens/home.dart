import 'package:flutter/material.dart';
import 'package:pdf_reader/model/pdf_files_model.dart';
import 'package:pdf_reader/model/sort_by.dart';
import 'package:pdf_reader/screens/favourite_screen.dart';
import 'package:pdf_reader/screens/home_screen.dart';
import 'package:pdf_reader/screens/search_files_screen.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> screens = [HomeScreen(), FavouriteScreen()];
  int activeScreen = 0;
  @override
  void initState() {
    super.initState();

    // assign this variable your Future
  }

  void sortFiles(SortBy sortBy) {
    Provider.of<PdfFilesModel>(context, listen: false).sortFiles(sortBy);
  }

  @override
  Widget build(BuildContext context) {
    var fileProvider = Provider.of<PdfFilesModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Reader'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
                context: context,
                delegate:
                    SearchFilesScreen(filesList: fileProvider.allPdfFiles)),
          ),
          PopupMenuButton(
            onSelected: (SortBy value) => sortFiles(value),
            child: Icon(Icons.sort),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Sort by name'),
                value: SortBy.Name,
              ),
              PopupMenuItem(
                child: Text('Sort by size'),
                value: SortBy.Size,
              ),
              PopupMenuItem(
                child: Text('Sort by date'),
                value: SortBy.Date,
              ),
            ],
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.folder_open_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Browse more files'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.folder_open_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Browse more files'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.folder_open_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Browse more files'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.folder_open_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Browse more files'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.folder_open_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Browse more files'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.folder_open_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Browse more files'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.folder_open_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Browse more files'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeScreen,
        onTap: (index) {
          setState(() {
            activeScreen = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
        ],
      ),
      body: screens[activeScreen],
    );
  }
}
