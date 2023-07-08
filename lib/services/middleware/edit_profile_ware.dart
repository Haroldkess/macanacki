import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macanacki/model/comments_model.dart';
import 'package:macanacki/model/create_post_model.dart';
import 'package:macanacki/services/backoffice/create_post_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/backoffice/edit_profile_office.dart';

import '../../presentation/widgets/debug_emitter.dart';

class EditProfileWare extends ChangeNotifier {
  bool _loadStatus = false;

  File? file;
  String _message = 'Something went wrong';

  bool get loadStatus => _loadStatus;

  String get message => _message;

  void disposeValue() async {
    _message = "";
    notifyListeners();
  }

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void addFile(
    File selectedFile,
  ) {
    file = selectedFile;

    notifyListeners();
  }

  Future<bool> editProfileFromApi(
    EditProfileModel data,
  ) async {
    late bool isSuccessful;

    try {
      http.StreamedResponse? response = await editProfile(data);

      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        log(res.body);

        _message = jsonData["message"];
        isSuccessful = true;
      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        _message = jsonData["message"];
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      emitter(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
