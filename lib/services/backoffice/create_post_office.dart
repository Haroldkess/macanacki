import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:makanaki/model/create_post_model.dart';
import 'package:makanaki/services/api_url.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.StreamedResponse?> createPost(
  CreatePostModel data,
) async {
  http.StreamedResponse? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  final filePhotoName = basename(data.media!.path);
  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/post/create"));
  Map<String, String> headers = {
    'Accept': 'application/json',
    'authorization': 'Bearer $token',
  };
  var filePhoto = await http.MultipartFile.fromPath('media', data.media!.path,
      filename: filePhotoName);

  request.headers.addAll(headers);
  request.fields["description"] = data.description!;
  request.fields["published"] = data.published!.toString();
  request.fields["btn_id"] = data.btnId!.toString();
  request.fields["btn_link"] = data.url!.toString();
  request.files.add(filePhoto);

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
    );

    // log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}
