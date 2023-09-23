import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/presentation/screens/onboarding/business/business_modal.dart';
import 'package:macanacki/services/backoffice/registeration_office.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/register_model.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/snack_msg.dart';
import '../backoffice/forget_pass_office.dart';
import '../temps/temps_id.dart';

class RegisterationWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  bool _loadStatus3 = false;
  bool loadBus = false;
  bool loadUser = false;
  String optMsg = "Something went wrong. Please try again";
  String _message = 'Something went wrong';
  String _message2 = 'Something went wrong';
  String _busMsg = 'Something went wrong';
  String _IndividualMsg = 'Something went wrong';
  String _token = "";

  bool _verifyName = false;
  bool sendForgetOtp = false;
  bool sendPass = false;

  String get message => _message;
  String get message2 => _message2;
  String get busMsg => _busMsg;
  String get IndividualMsg => _IndividualMsg;

  bool get loadStatus => _loadStatus;

  bool get loadStatus2 => _loadStatus2;
  bool get loadStatus3 => _loadStatus3;
  bool get verifyName => _verifyName;

  Future<void> isLoadSendOtp(bool isLoad) async {
    sendForgetOtp = isLoad;
    notifyListeners();
  }

  Future<void> forgetLoad(bool isLoad) async {
    sendPass = isLoad;
    notifyListeners();
  }

  Future<void> isLoading(bool isLoad) async {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<void> isLoadingBus(bool isLoad) async {
    loadBus = isLoad;
    notifyListeners();
  }

  Future<void> isLoadingUser(bool isLoad) async {
    loadUser = isLoad;
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
          .whenComplete(() => emitter("register email request done"));
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
          .whenComplete(() => emitter("register username request done"));
      if (response == null) {
        isSuccessful = false;
        emitter("register username request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        emitter("register username request success");
        isSuccessful = true;
      } else {
        emitter("register username request failed");
        // ignore: use_build_context_synchronously
        //showToast(context, ain"something went wrong. pls try ag", Colors.red);
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      emitter("register username request failed");
      emitter(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> registerUserFromApi(
    RegisterUserModel data,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    late bool isSuccessful;
    // log(data.photo!.path);
    // log(data.genderId.toString());
    // log(data.dob.toString());
    // log(data.photo!.path);

    try {
      http.StreamedResponse? response = await completeRegisteration(data);

      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        _token = jsonData["data"]["accessToken"].toString();
        await pref.setString(tokenKey, _token);
        emitter(jsonData["message"]);
        _message2 = jsonData["message"];
        isSuccessful = true;
        emitter("this user is registered");

        //  var res = http.Response.fromStream(response);
      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        emitter(jsonData["message"]);
        _message2 = jsonData["message"];
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      emitter(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> verifyUsernameFromApi(
    String name,
  ) async {
    late bool isSuccessful;
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String savedEmail = pref.getString(emailKey) ?? '';

      http.Response? response = await verifyUserName(name, savedEmail)
          .whenComplete(() => emitter(" request done"));
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

  Future<bool> verifyBusinessFromApi(
    RegisterBusinessModel data,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    late bool isSuccessful;

    try {
      http.StreamedResponse? response = await verifyBusiness(data);

      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        try {
          var jsonData = jsonDecode(res.body);
          //    _token = jsonData["data"]["accessToken"].toString();
          //   await pref.setString(tokenKey, _token);
          //  emitter("verification done");
          _busMsg = jsonData["message"];
        } catch (e) {}
        isSuccessful = true;
        log(res.body);

        //  var res = http.Response.fromStream(response);
      } else {
        final res = await http.Response.fromStream(response);
        //  var jsonData = jsonDecode(res.body);
        try {
          var jsonData = jsonDecode(res.body);
          _busMsg = jsonData["message"];
        } catch (e) {
          _busMsg = "Something went wrong";
        }
//log(res.body);
        // _message2 = jsonData["message"];
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      emitter(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> verifyUserFromApi(
    VerifyUserModel data,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    late bool isSuccessful;

    try {
      http.StreamedResponse? response = await verifyUser(data);

      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        // var jsonData = jsonDecode(res.body);
        //    _token = jsonData["data"]["accessToken"].toString();
        //   await pref.setString(tokenKey, _token);
        try {
          var jsonData = jsonDecode(res.body);
          //    _token = jsonData["data"]["accessToken"].toString();
          //   await pref.setString(tokenKey, _token);
          //  emitter("verification done");
          _IndividualMsg = jsonData["message"];
        } catch (e) {}
        //   _message2 = jsonData["message"];
        log(res.body);
        isSuccessful = true;
        //   log("this user is registered");

        //  var res = http.Response.fromStream(response);
      } else {
        final res = await http.Response.fromStream(response);
        try {
          var jsonData = jsonDecode(res.body);
          _IndividualMsg = jsonData["message"];
        } catch (e) {
          _IndividualMsg = "Something went wrong";
        }
        emitter(res.body.toString());
        // _message2 = jsonData["message"];
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      emitter(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> sendForgetOtpFromApi(String email) async {
    late bool isSuccessful;
    try {
      http.Response? response = await forgetSendOtp(email)
          .whenComplete(() => emitter("otp sent gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 201) {
        var jsonData = jsonDecode(response.body);

        try {
          optMsg = jsonData["message"];
        } catch (e) {
          emitter(e.toString());
        }

        //  var incomingData = CategoryModel.fromJson(jsonData);
        //category = incomingData.data!;

        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        try {
          optMsg = jsonData["message"];
        } catch (e) {
          optMsg = "Can't send otp for password at the moment please try again";
          emitter(e.toString());
        }

        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> changePasswordFromApi(
      String email, String otp, String pass) async {
    late bool isSuccessful;
    try {
      http.Response? response = await forgeetPasswordSend(email, otp, pass)
          .whenComplete(() => emitter("forget pass sent gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        try {
          optMsg = jsonData["message"];
        } catch (e) {
          emitter(e.toString());
        }

        //  var incomingData = CategoryModel.fromJson(jsonData);
        //category = incomingData.data!;

        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        try {
          optMsg = jsonData["message"];
        } catch (e) {
          optMsg = "Can't change password at the moment please try again";
          emitter(e.toString());
        }

        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    notifyListeners();

    return isSuccessful;
  }
}
