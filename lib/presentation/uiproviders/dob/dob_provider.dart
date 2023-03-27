import 'package:flutter/cupertino.dart';

class DobProvider extends ChangeNotifier {
  String month = "MONTH";
  String year = "YEAR";
  String day = "DAY";

  void changeDob(DateTime dob) {
    month = dob.month.toString();
    year = dob.year.toString();

    day = dob.day.toString();

    notifyListeners();
  }
}
