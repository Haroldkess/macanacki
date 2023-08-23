import 'package:flutter/cupertino.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../model/category_model.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../backoffice/category_office.dart';

class CategoryWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Cant get category at the moment";

  List<Datum> category = [];
  Datum selected = Datum();

  bool get loadStatus => _loadStatus;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void selectCat(Datum data) {
    selected = data;

    notifyListeners();
  }

  Future<bool> getCatFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getCategory()
          .whenComplete(() => emitter("category gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = CategoryModel.fromJson(jsonData);
        category = incomingData.data!;

        isSuccessful = true;
      } else {
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    notifyListeners();

    return isSuccessful;
  }
}
