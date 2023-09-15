import 'package:flutter/cupertino.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/model/plan_model.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../model/button_model.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../backoffice/button_office.dart';
import '../backoffice/plan_office.dart';

class ButtonWare extends ChangeNotifier {
  bool _loadStatus = false;
  String _message = "can not get buttons at the moment";
  List<ButtonData> buttons = [];
  String url = "";
  ButtonData buttonData = ButtonData();
  int _index = 0;

  String code = "";
  String name = "";

  String get message => _message;

  bool get loadStatus => _loadStatus;
  int get index => _index;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void addData(ButtonData data) {
    buttonData = data;
    notifyListeners();
  }

  void addUrl(String add) {
    url = add;
    notifyListeners();
  }

  void addCode(String add) {
    code = add;
    notifyListeners();
  }

  void addName(String add) {
    name = add;
    notifyListeners();
  }

  void addIndex(int add) {
    _index = add;
    notifyListeners();
  }

  Future<bool> getButtonFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getButtons()
          .whenComplete(() => emitter("buttons gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //      log("get gender request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = ButtonModel.fromJson(jsonData);
        buttons = incomingData.data!;
        _message = incomingData.message!.toString();

        //    log("plans  request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        var incomingData = ButtonModel.fromJson(jsonData);
        _message = incomingData.message!.toString();

        //  log("plans  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      // log("get gender  request failed");
      //   log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
