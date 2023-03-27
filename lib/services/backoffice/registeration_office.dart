import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/services/api_url.dart';
import 'package:path/path.dart';

import '../../model/register_model.dart';

Future<http.Response?> registerEmail(SendEmailModel data) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse('$baseUrl/public/api/user/register'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data.toJson()));

    log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> registerUserName(SendUserNameModel data) async {
  http.Response? response;
  try {
    response =
        await http.post(Uri.parse('$baseUrl/public/api/user/register/stage2'),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode(data.toJson()));

    log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.StreamedResponse?> completeRegisteration(
  RegisterUserModel data,
) async {
  http.StreamedResponse? response;

  final filePhotoName = basename(data.photo!.path);
  List<dynamic> photo = [filePhotoName];

  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/user/register/complete"));
  Map<String, String> headers = {'Accept': 'application/json'};
  var filePhoto = await http.MultipartFile.fromPath('photo', data.photo!.path,
      filename: filePhotoName);

  request.headers.addAll(headers);
  request.fields["email"] = data.email!;
  request.fields["gender_id"] = data.genderId!.toString();
  request.fields["dob"] = data.dob!.toString();
  request.files.add(filePhoto);
  request.fields["password"] = data.password!;

  try {
    response = await request.send();
  } catch (e) {
    log("hello");
    log(e.toString());
    response = null;
  }

  return response;
}
