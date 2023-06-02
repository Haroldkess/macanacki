import 'package:flutter/cupertino.dart';
import 'package:makanaki/model/gender_model.dart';
import 'package:makanaki/model/plan_model.dart';
import 'package:makanaki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../presentation/widgets/debug_emitter.dart';
import '../backoffice/plan_office.dart';

class PlanWare extends ChangeNotifier {
  bool _loadStatus = false;
  String _message = "can not get plans at the moment";

  int _index = 1;

  int amount = 0;

  String get message => _message;

  List<PlanData> _plans = [];

  bool get loadStatus => _loadStatus;
  int get index => _index;
  List<PlanData> get plans => _plans;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void selectPlan(int num) {
    _index = num;
    notifyListeners();
  }



  void addAmount(int  paying) {
    amount = paying;
    notifyListeners();
  }

  Future<bool> getPlansFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response =
          await getPlan().whenComplete(() => emitter("plans gotten successfully"));
      if (response == null) {
        isSuccessful = false;
  //      log("get gender request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = PlanModel.fromJson(jsonData);
        _plans = incomingData.data!;
        _message = incomingData.message!.toString();

    //    log("plans  request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        var incomingData = PlanModel.fromJson(jsonData);
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
