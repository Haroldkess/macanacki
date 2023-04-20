import 'package:flutter/cupertino.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Temp extends ChangeNotifier {
  SharedPreferences? _pref;

  String _userName = "";
  
  String _dp = "";

  String get userName => _userName;

  String get dp => _dp;

  SharedPreferences get pref => _pref!;

  Future<void> initPref() async {
    _pref = await SharedPreferences.getInstance();
    notifyListeners();
  }

  Future<void> addUserName(String name) async {
    await initPref();
    _pref!.setString(userNameKey, name);
    _userName = name;
    notifyListeners();
  }

    Future<void> addDp(String photo) async {
    await initPref();
    _pref!.setString(dpKey, photo);
    _dp = photo;
    notifyListeners();
  }

  Future<void> addEmailTemp(String email) async {
    await initPref().whenComplete(() => _pref!.setString(emailKey, email));
    notifyListeners();
  }

  Future<void> addUserNameTemp(String userName) async {
    await initPref()
        .whenComplete(() => _pref!.setString(userNameKey, userName));
    notifyListeners();
  }

  Future<void> addPasswordTemp(String password) async {
    await initPref()
        .whenComplete(() => _pref!.setString(passwordKey, password));
    notifyListeners();
  }

  Future<void> addGenderIdTemp(int id) async {
    await initPref().whenComplete(() => _pref!.setInt(genderId, id));
    notifyListeners();
  }

  Future<void> addDobTemp(String dob) async {
    await initPref().whenComplete(() => _pref!.setString(dobKey, dob));
    notifyListeners();
  }

  Future<void> addPhotoTemp(String pic) async {
    await initPref().whenComplete(() => _pref!.setString(photoKey, pic));
    notifyListeners();
  }

  Future<void> addFacialTemp(String facial) async {
    await initPref()
        .whenComplete(() => _pref!.setString(facialUploadKey, facial));
    notifyListeners();
  }

  Future<void> addIsLoggedInTemp(bool logged) async {
    await initPref().whenComplete(() => _pref!.setBool(isLoggedInKey, logged));
    notifyListeners();
  }
}
