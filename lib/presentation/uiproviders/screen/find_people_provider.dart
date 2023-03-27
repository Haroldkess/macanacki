import 'package:flutter/cupertino.dart';

class FindPeopleProvider extends ChangeNotifier {
  bool isFound = false;

  void found(bool status) {
    isFound = status;
    notifyListeners();
  }
}
