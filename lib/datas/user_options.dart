import 'package:shared_preferences/shared_preferences.dart';

class UserOptions {

  static bool _savePdfToStorage;

  static getOptionsFromDevice() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _savePdfToStorage = sharedPreferences.getBool('savePdfToStorage') ?? true;
  }

  static void _saveOptionBool(String key, bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, value);
  }
  static void _saveOptionInt(String key, int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(key, value);
  }


  static set savePdfToStorage(bool value) {
    _savePdfToStorage = value;
    _saveOptionBool('savePdfToStorage', _savePdfToStorage);
  }

  static bool get savePdfToStorage => _savePdfToStorage;
}