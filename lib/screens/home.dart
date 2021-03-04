// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_reader/model/app_options.dart';
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
              delegate: SearchFilesScreen(filesList: fileProvider.allPdfFiles),
            ),
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
            onSelected: (AppOptions option) async {
              if (option == AppOptions.BrowseMoreFIles) {
                // FilePickerResult result = await FilePicker.platform.pickFiles(
                //   type: FileType.custom,
                //   allowedExtensions: ['pdf'],
                // );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Browse more files'),
                  ],
                ),
                value: AppOptions.BrowseMoreFIles,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.access_alarms_rounded, color: Colors.amber),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Remove Ads'),
                  ],
                ),
                value: AppOptions.RemoveAds,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Rate us'),
                  ],
                ),
                value: AppOptions.RateUs,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.feedback,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Send feedback'),
                  ],
                ),
                value: AppOptions.SendFeedback,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Share this app'),
                  ],
                ),
                value: AppOptions.ShareThisApp,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.sanitizer_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Privacy policy'),
                  ],
                ),
                value: AppOptions.PrivacyPolicy,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.indeterminate_check_box,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Change language'),
                  ],
                ),
                value: AppOptions.ChangeLanguage,
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
            icon: Icon(Icons.star),
            label: 'Favourite',
          ),
        ],
      ),
      body: screens[activeScreen],
    );
  }
}
