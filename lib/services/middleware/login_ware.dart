import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/services/backoffice/login_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWare extends ChangeNotifier {
  bool _loadStatus = false;
  String _message = 'Something went wrong';
  String _token = "";

  String get message => _message;

  bool get loadStatus => _loadStatus;
  String get token => _token;

  Future<void> isLoading(bool isLoad) async {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<bool> loginUserFromApi(
    SendLoginModel body,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    late bool isSuccessful;
    log("hello");
    try {
      http.Response? response = await loginUser(body)
          .whenComplete(() => log("login user request done"));
      if (response == null) {
        _message = "Something went wrong";
        isSuccessful = false;
        log("login user  request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        _message = jsonData["message"].toString();
        _token = jsonData["data"]["access_token"].toString();
        await pref.setString(tokenKey, _token);
        log("login user  request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        _message = jsonData["message"].toString();

        log("login user  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("login user  request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
