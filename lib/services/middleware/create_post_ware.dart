import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makanaki/model/comments_model.dart';
import 'package:makanaki/model/create_post_model.dart';
import 'package:makanaki/services/backoffice/create_post_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../presentation/widgets/debug_emitter.dart';

class CreatePostWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  bool loadEditPost = false;
  CommentData comments = CommentData();
  List<File>? file;
  File? idUser;
  File? idBusiness;
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

  void isLoadingEdit(bool isLoad) {
    loadEditPost = isLoad;
    notifyListeners();
  }

  void isLoading2(bool isLoad) {
    _loadStatus2 = isLoad;
    notifyListeners();
  }

  void addFile(
    List<File> selectedFile,
  ) {
    file = selectedFile;

    notifyListeners();
  }

  void addIdUser(
    File selectedFile,
  ) {
    idUser = selectedFile;

    notifyListeners();
  }

  void addIdBusiness(
    File selectedFile,
  ) {
    idBusiness = selectedFile;

    notifyListeners();
  }

  void removeFile(
    int index,
  ) {
    file!.removeAt(index);
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
      emitter(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> shareCommentFromApi(ShareCommentsModel body, int id) async {
    late bool isSuccessful;
    try {
      http.Response? response = await shareComment(body, id)
          .whenComplete(() => emitter("share comment request done"));
      if (response == null) {
        _commentMessage = "Something went wrong";
        isSuccessful = false;
        emitter("share comment request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        comments = CommentData.fromJson(jsonData["data"]);
        _commentMessage = jsonData["message"].toString();
        emitter("share comment request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        _commentMessage = jsonData["message"].toString();
        emitter("share comment request else failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //   log("share comment request failed");
      emitter(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> deletePostFromApi(int id) async {
    late bool isSuccessful;
    try {
      http.Response? response =
          await deletePost(id).whenComplete(() => emitter("delete request done"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
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

  Future<bool> editPostFromApi(EditPost data, int id) async {
    late bool isSuccessful;
    try {
      http.Response? response = await editPost(data, id)
          .whenComplete(() => emitter("edit  request done"));
      if (response == null) {
        emitter("null");
        isSuccessful = false;
      } else if (response.statusCode == 201) {
        isSuccessful = true;
      } else {
        emitter("else");
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
