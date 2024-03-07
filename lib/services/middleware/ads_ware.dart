import 'package:flutter/cupertino.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/services/backoffice/ads_office.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../model/ads_price_model.dart';
import '../../model/category_model.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../backoffice/category_office.dart';

class AdsWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  String message = "Cant get ad pricing  at the moment";
  String message2 = "Cant promote post at the moment";

  List<AdsData> adsPrice = [];
  AdsData selected = AdsData();
  String duration = "select";

  bool get loadStatus => _loadStatus;

  bool get loadStatus2 => _loadStatus2;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void isLoading2(bool isLoad) {
    _loadStatus2 = isLoad;
    notifyListeners();
  }

  void selectCat(AdsData data) {
    selected = data;

    notifyListeners();
  }

  void addDuration(String data) {
    duration = data;

    notifyListeners();
  }

  Future<bool> getAdsFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getAdsPrice()
          .whenComplete(() => emitter("ad price gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = AdsPriceModel.fromJson(jsonData);
        adsPrice = incomingData.data!;

        isSuccessful = true;
      } else {
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    notifyListeners();

    return isSuccessful;
  }

  void clear() {
    selected = AdsData();
    duration = "select";
    notifyListeners();
  }

  Future<bool> sendAdsFromApi(SendAdModel data) async {
    late bool isSuccessful;
    print(" ----- Inside SendAdFrom API");
    try {
      http.Response? response = await sendAd(data)
          .whenComplete(() => emitter("ad price gotten successfully"));
      if (response == null) {
        print(" ----- Inside Error - Null");
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        print(" ----- Inside Success");
        var jsonData = jsonDecode(response.body);

        try {
          message2 = jsonData["message"];
        } catch (e) {
          emitter(e.toString());
        }

        //  var incomingData = CategoryModel.fromJson(jsonData);
        //category = incomingData.data!;

        isSuccessful = true;
      } else {
        print(" ----- Inside Something went wrong");
        var jsonData = jsonDecode(response.body);
        print(jsonData);

        try {
          message2 = jsonData["message"];
        } catch (e) {
          message2 = "Cant promote post at the moment";
          emitter(e.toString());
        }

        isSuccessful = false;
      }
    } catch (e) {
      print(" ----- Inside Catch - Error");
      isSuccessful = false;
    }

    notifyListeners();

    return isSuccessful;
  }
}
