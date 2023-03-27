import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../model/search_user_model.dart';
import '../backoffice/search_office.dart';

class SearchWare extends ChangeNotifier {
  List<UserSearchData> _userFound = [];
  bool _loadStatus = false;

  bool get loadStatus => _loadStatus;

  List<UserSearchData> get userFound => _userFound;

  Future<void> isLoading(bool isLoad) async {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<void> clearSearch() async {
    _userFound.clear();
    notifyListeners();
  }

  Future<bool> getSearchedUserFromApi(String x) async {
    late bool isSuccessful;
    try {
      http.Response? response = await getSearchByUser(x)
          .whenComplete(() => log("search finished successfully"));
      if (response == null) {
        isSuccessful = false;
        log("search data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = UserSearchModel.fromJson(jsonData);
        _userFound = incomingData.data!;

        log("search  data  request success");
        isSuccessful = true;
      } else {
        log("search data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("get user profile data  request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
