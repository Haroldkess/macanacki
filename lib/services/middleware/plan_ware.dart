import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/model/plan_model.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../model/diamond_purchase_link_model.dart';
import '../../model/promote_post_link_model.dart';
import '../../model/verification_link_model.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/float_toast.dart';
import '../backoffice/plan_office.dart';
import '../controllers/url_launch_controller.dart';

class PlanWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool loadDiamond = false;
  bool loadVerification = false;
  bool loadPromote = false;
  String _message = "can not get plans at the moment";

  int _index = 1;

  int amount = 0;

  String get message => _message;

  List<PlanData> _plans = [];
  DiamondLink diamondLink = DiamondLink();
  PromoteLink promoteLink = PromoteLink();
  VerificationLink verificationLink = VerificationLink();

  bool get loadStatus => _loadStatus;
  int get index => _index;
  List<PlanData> get plans => _plans;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void isLoadingPromote(bool isLoad) {
    loadPromote = isLoad;
    notifyListeners();
  }

  void isLoadingDiamond(bool isLoad) {
    loadDiamond = isLoad;
    notifyListeners();
  }

  void isLoadingVerificatioin(bool isLoad) {
    loadVerification = isLoad;
    notifyListeners();
  }

  void selectPlan(int num) {
    _index = num;
    notifyListeners();
  }

  void addAmount(int paying) {
    amount = paying;
    notifyListeners();
  }

  Future<bool> getPlansFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getPlan()
          .whenComplete(() => emitter("plans gotten successfully"));
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

  Future<bool> getDiamondLinkFromApi(String amount) async {
    late bool isSuccessful;
    try {
      http.Response? response = await getPurchaseDiamondLink(amount)
          .whenComplete(() => emitter("diamond link gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //      log("get gender request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = DiamondLink.fromJson(jsonData);
        diamondLink = incomingData;

        isSuccessful = true;
        if (Platform.isAndroid) {
          UrlLaunchController.launchWebViewOrVC(
              Uri.parse(diamondLink.paymentLink!));
        } else {
          UrlLaunchController.launchInWebViewOrVC(
              Uri.parse(diamondLink.paymentLink!));
        }
      } else {
        var jsonData = jsonDecode(response.body);
        floatToast(jsonData["message"], const Color.fromARGB(255, 109, 84, 84));

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

  Future<bool> getVerificationLinkFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getVerificationLink()
          .whenComplete(() => emitter("plans gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //      log("get gender request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = VerificationLink.fromJson(jsonData);
        verificationLink = incomingData;
        isSuccessful = true;
        if (Platform.isAndroid) {
          UrlLaunchController.launchWebViewOrVC(
              Uri.parse(verificationLink.paymentLink!));
        } else {
          UrlLaunchController.launchInWebViewOrVC(
              Uri.parse(verificationLink.paymentLink!));
        }
      } else {
        var jsonData = jsonDecode(response.body);
        floatToast(jsonData["message"], const Color.fromARGB(255, 109, 84, 84));

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

  Future<bool> getPromotePostLinkFromApi(postId, planId) async {
    late bool isSuccessful;
    try {
      http.Response? response = await getPromotePostLink(postId, planId)
          .whenComplete(() => emitter("post gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //      log("get gender request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = PromoteLink.fromJson(jsonData);
        promoteLink = incomingData;
        isSuccessful = true;
        if (Platform.isAndroid) {
          UrlLaunchController.launchWebViewOrVC(
              Uri.parse(promoteLink.paymentLink!));
        } else {
          UrlLaunchController.launchInWebViewOrVC(
              Uri.parse(promoteLink.paymentLink!));
        }
      } else {
        var jsonData = jsonDecode(response.body);
        floatToast(jsonData["message"], const Color.fromARGB(255, 109, 84, 84));

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
