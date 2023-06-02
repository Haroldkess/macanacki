import 'package:flutter/cupertino.dart';

class FindPeopleProvider extends ChangeNotifier {
  bool isFound = false;
  String SearchInProfile = "";

  void search(String data) {
    SearchInProfile = data;
    notifyListeners();
  }

  void found(bool status) {
    isFound = status;
    notifyListeners();
  }
}
