import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardProvider extends ChangeNotifier {
  bool _addHeight = false;
  bool _isTyping = false;

  bool get isTyping => _isTyping;
    bool get addHeight => _addHeight;


  Future increase(bool add) async {
    _addHeight = add;

    notifyListeners();
  }

  Future typeMsg(bool type) async {
    _isTyping = type;

    notifyListeners();
  }
}
