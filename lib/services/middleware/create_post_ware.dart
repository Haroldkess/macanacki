import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makanaki/model/comments_model.dart';
import 'package:makanaki/model/create_post_model.dart';
import 'package:makanaki/services/backoffice/create_post_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class CreatePostWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  CommentData comments = CommentData();
  File? file;
  String _message = 'Something went wrong';
  String _commentMessage = 'Something went wrong';
  bool get loadStatus => _loadStatus;
  bool get loadStatus2 => _loadStatus2;
  String get message => _message;
  String get commentMessage => _commentMessage;

  void disposeValue() async {
  
    comments = CommentData();
    _message = "";
    _commentMessage = "";

    notifyListeners();
  }

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void isLoading2(bool isLoad) {
    _loadStatus2 = isLoad;
    notifyListeners();
  }

  void addFile(
    File selectedFile,
  ) {
    file = selectedFile;

    notifyListeners();
  }

  Future<bool> createPostFromApi(
    CreatePostModel data,
  ) async {
    late bool isSuccessful;
  //  log(data.media!.path);
  //  log(data.description.toString());
   // log(data.published.toString());

    try {
      http.StreamedResponse? response = await createPost(data);

      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 201) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);

    //    log(jsonData["message"]);
        _message = jsonData["message"];
        isSuccessful = true;
      //  log("post created!!");

        //  var res = http.Response.fromStream(response);

      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
     //   log(jsonData["message"]);
        _message = jsonData["message"];
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> shareCommentFromApi(ShareCommentsModel body, int id) async {
    late bool isSuccessful;
    try {
      http.Response? response = await shareComment(body, id)
          .whenComplete(() => log("share comment request done"));
      if (response == null) {
        _commentMessage = "Something went wrong";
        isSuccessful = false;
     //   log("share comment request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        comments = CommentData.fromJson(jsonData["data"]);
        _commentMessage = jsonData["message"].toString();
     //   log("share comment request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        _commentMessage = jsonData["message"].toString();
     //   log("share comment request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
   //   log("share comment request failed");
    //  log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
