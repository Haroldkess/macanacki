import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/services/backoffice/registeration_office.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/register_model.dart';
import '../../presentation/widgets/snack_msg.dart';
import '../temps/temps_id.dart';

class RegisterationWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  bool _loadStatus3 = false;
  String _message = 'Something went wrong';
  String _message2 = 'Something went wrong';
  String _token = "";

  bool _verifyName = false;

  String get message => _message;
  String get message2 => _message2;

  bool get loadStatus => _loadStatus;

  bool get loadStatus2 => _loadStatus2;
  bool get loadStatus3 => _loadStatus3;
  bool get verifyName => _verifyName;

  Future<void> isLoading(bool isLoad) async {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<void> isLoading2(bool isLoad2) async {
    _loadStatus2 = isLoad2;
    notifyListeners();
  }

  Future<void> isLoading3(bool isLoad3) async {
    _loadStatus3 = isLoad3;
    notifyListeners();
  }

  Future<bool> registerEmailFromApi(
    SendEmailModel body,
  ) async {
    late bool isSuccessful;
    try {
      http.Response? response = await registerEmail(body)
          .whenComplete(() => log("register email request done"));
      if (response == null) {
        _message = "Something went wrong";
        isSuccessful = false;
     //   log("register email request failed");
      } else if (response.statusCode == 201) {
        var jsonData = jsonDecode(response.body);
        _message = jsonData["message"].toString();
      //  log("register email request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        _message = jsonData["message"].toString();
      //  log("register email request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
     // log("register email request failed");
     // log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> registerUsernameFromApi(
    SendUserNameModel body,
  ) async {
    late bool isSuccessful;
    try {
      http.Response? response = await registerUserName(body)
          .whenComplete(() => log("register username request done"));
      if (response == null) {
        isSuccessful = false;
        log("register username request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        log("register username request success");
        isSuccessful = true;
      } else {
        log("register username request failed");
        // ignore: use_build_context_synchronously
        //showToast(context, ain"something went wrong. pls try ag", Colors.red);
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("register username request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> registerUserFromApi(
    RegisterUserModel data,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    late bool isSuccessful;
    log(data.photo!.path);
    log(data.genderId.toString());
    log(data.dob.toString());
    log(data.photo!.path);

    try {
      http.StreamedResponse? response = await completeRegisteration(data);

      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        _token = jsonData["data"]["accessToken"].toString();
        await pref.setString(tokenKey, _token);
        log(jsonData["message"]);
        _message2 = jsonData["message"];
        isSuccessful = true;
        log("this user is registered");

        //  var res = http.Response.fromStream(response);

      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        log(jsonData["message"]);
        _message2 = jsonData["message"];
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> verifyUsernameFromApi(
    String name,
  ) async {
    late bool isSuccessful;
    try {
      http.Response? response =
          await verifyUserName(name).whenComplete(() => log(" request done"));
      if (response == null) {
        _verifyName = false;
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        _verifyName = true;

        isSuccessful = true;
      } else {
          _verifyName = false;
        // ignore: use_build_context_synchronously
        //showToast(context, ain"something went wrong. pls try ag", Colors.red);
        isSuccessful = false;
      }
    } catch (e) {
      _verifyName = false;
      isSuccessful = false;
      
    }

    notifyListeners();

    return isSuccessful;
  }
}
