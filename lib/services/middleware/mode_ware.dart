import 'package:flutter/cupertino.dart';
import 'package:makanaki/services/backoffice/mode_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../presentation/widgets/debug_emitter.dart';



class ModeWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Something went wrong";

  bool get loadStatus => _loadStatus;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<bool> modeFromApi(String body,) async {
    late bool isSuccessful;
    try {
      http.Response? response = await mode(body)
          .whenComplete(() => emitter("mode request sent"));
      if (response == null) {
        isSuccessful = false;
     //   log("mode  request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        message = jsonData["message"];

       // log("mode request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        message = jsonData["message"];
       // log(jsonData["message"]);
      //  log("mode request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
  //    log("mode request failed");
    }
    notifyListeners();
    return isSuccessful;
  }


}
