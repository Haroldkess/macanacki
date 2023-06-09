import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/model/create_post_model.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/widgets/debug_emitter.dart';

Future<http.StreamedResponse?> createPost(
  CreatePostModel data,
) async {
  http.StreamedResponse? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  // final filePhotoName = basename(data.media!.path);
  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/post/create"));
  Map<String, String> headers = {
    'Accept': 'application/json',
    'authorization': 'Bearer $token',
  };
  List<http.MultipartFile> filePhoto = [];
  // await Future.forEach(data.media!, (element) async {
  //   var f = await http.MultipartFile.fromPath('media', element.path,
  //       filename: basename(element.path));
  //   filePhoto.add(f);
  // });
  for (var i = 0; i < data.media!.length; i++) {
    var f = await http.MultipartFile.fromPath('media[$i]', data.media![i].path,
        filename: basename(data.media![i].path));
    filePhoto.add(f);
  }

  // var filePhoto = await http.MultipartFile.fromPath('media', data.media!.path,
  //     filename: filePhotoName);

  request.headers.addAll(headers);
  request.fields["description"] = data.description!;
  request.fields["published"] = data.published!.toString();
  request.fields["btn_id"] = data.btnId!.toString();
  request.fields["btn_link"] = data.url!.toString();
  request.files.addAll(filePhoto.toList());

  try {
    response = await request.send();
  } catch (e) {
    //   log("hello");
    //   log(e.toString());
    response = null;
  }

  return response;
}

Future<http.Response?> shareComment(ShareCommentsModel data, int id) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
//  print("this is the id $id");
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/post/$id/comment?body=${data.body}'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      // body: jsonEncode(data.toJson())
    ).timeout(const Duration(seconds: 30));

    log(response.body.toString());
    log(response.statusCode.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> deletePost(int id) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
//  print("this is the id $id");
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/post/$id/delete'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      // body: jsonEncode(data.toJson())
    );

    //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> deleteComment(int postId, int commentId) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
//  print("this is the id $id");
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/post/$postId/comment/$commentId/delete'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      // body: jsonEncode(data.toJson())
    );

    //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> editPost(EditPost data, int id) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
//  print("this is the id $id");
  try {
    response = await http.post(Uri.parse('$baseUrl/public/api/post/$id/edit'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
        body: jsonEncode(data.toJson()));

    //   log(response.body.toString());
  } catch (e) {
    response = null;
    emitter(e.toString());
  }
  return response;
}
