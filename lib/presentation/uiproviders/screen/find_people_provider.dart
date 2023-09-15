import 'package:flutter/cupertino.dart';

class FindPeopleProvider extends ChangeNotifier {
  bool isFound = false;
  String SearchInProfile = "";
  String country = "";
  String state = "";
  String city = "";

  void addLocation(String c, s) async {
    country = c;
    state = s;
    notifyListeners();
  }

  void search(String data) {
    SearchInProfile = data;
    notifyListeners();
  }

  void found(bool status) {
    isFound = status;
    notifyListeners();
  }
}
