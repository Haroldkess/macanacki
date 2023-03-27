import 'package:flutter/cupertino.dart';

class TabProvider extends ChangeNotifier {
  int index = 0;
  bool isChanged = false;

  void changeIndex(int _index) {
    index = _index;
    notifyListeners();
  }

    Future <void> changePage(bool change) async {
    isChanged = change;
    notifyListeners();
  }
}
