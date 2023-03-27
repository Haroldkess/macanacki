import 'package:flutter/cupertino.dart';
import 'package:makanaki/services/backoffice/otp_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../model/otp_model.dart';

class OtpWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Something went wrong";

  bool get loadStatus => _loadStatus;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<bool> verifyOtpFromApi(
    OtpModel body,
  ) async {
    late bool isSuccessful;
    try {
      http.Response? response = await verifyOtp(body)
          .whenComplete(() => log("verify  email request sent"));
      if (response == null) {
        isSuccessful = false;
        log("verify  email request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        message = jsonData["message"];

        log("verify  email request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        message = jsonData["message"];
        log(jsonData["message"]);
        log("verify  email request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("verify  email request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
