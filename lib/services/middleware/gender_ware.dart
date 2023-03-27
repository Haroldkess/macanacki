import 'package:flutter/cupertino.dart';
import 'package:makanaki/model/gender_model.dart';
import 'package:makanaki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class genderWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Cant get gender at the moment";

  List<GenderList> genderList = [];
   List<GenderList> selectedOne = [];

  bool get loadStatus => _loadStatus;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

    void selectGenderOptions(int id, bool tick) {
    GenderList isSelect =
        genderList.where((element) => element.id == id).first;
    List<GenderList> notSelect =
        genderList.where((element) => element.id != id).toList();

    if (tick) {
      isSelect.selected = tick;
      notSelect.forEach((element) {
        element.selected = false;
      });
    } else {
      notSelect.forEach((element) {
        element.selected = false;
      });
    }

    notifyListeners();
  }

  Future<bool> getGenderFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getGender()
          .whenComplete(() => log("gender gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        log("get gender request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = GenderModel.fromJson(jsonData);
        genderList = incomingData.data!;
        log(genderList.first.name!);

        log("get gender  request success");
        isSuccessful = true;
      } else {
        log("get gender  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("get gender  request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
