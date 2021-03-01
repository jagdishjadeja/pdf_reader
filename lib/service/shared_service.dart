import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static String favouriteKey = 'favourite';
  static getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favourite = prefs.getStringList(favouriteKey);
    print('Favourites : $favourite');
    return prefs;
  }

  static addToFavourite(String fileName) async {
    SharedPreferences pref = await SharedService.getInstance();
    var favourites = pref.getStringList(favouriteKey);
    favourites.add(fileName);
    pref.setStringList(favouriteKey, favourites);
  }

  static Future<void> removeFromFavourite(fileName) async {
    SharedPreferences pref = await SharedService.getInstance();
    var favourites = pref.getStringList(favouriteKey);
    if (favourites == null) {
      favourites = [];
    }
    favourites.remove(fileName);
    pref.setStringList(favouriteKey, favourites);
  }
}
