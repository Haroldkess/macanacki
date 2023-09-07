import 'package:flutter/cupertino.dart';
import 'package:macanacki/services/backoffice/otp_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../model/otp_model.dart';
import '../../presentation/widgets/debug_emitter.dart';

class OtpWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Something went wrong";
  String message1 = "Something went wrong";

  bool get loadStatus => _loadStatus;
  bool resend = false;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void resendLoad(bool isLoad) {
    resend = isLoad;
    notifyListeners();
  }

  Future<bool> verifyOtpFromApi(
    OtpModel body,
  ) async {
    late bool isSuccessful;
    try {
      http.Response? response = await verifyOtp(body)
          .whenComplete(() => emitter("verify  email request sent"));
      if (response == null) {
        isSuccessful = false;
        //    log("verify  email request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        message = jsonData["message"];

        //  log("verify  email request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        message = jsonData["message"];
        //   log(jsonData["message"]);
        //  log("verify  email request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //  log("verify  email request failed");
      //  log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> resendOtpFromApi(
    OtpModel body,
  ) async {
    late bool isSuccessful;
    try {
      http.Response? response = await resendOtp(body)
          .whenComplete(() => emitter("resend  otp request sent"));
      if (response == null) {
        isSuccessful = false;
        //    log("verify  email request failed");
      } else if (response.statusCode == 201) {
        var jsonData = jsonDecode(response.body);
        message1 = jsonData["message"];

        //  log("verify  email request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        message1 = jsonData["message"];
        //   log(jsonData["message"]);
        //  log("verify  email request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //  log("verify  email request failed");
      //  log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
