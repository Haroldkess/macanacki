import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/register_model.dart';
import '../../presentation/screens/onboarding/business/business_modal.dart';
import '../../presentation/widgets/debug_emitter.dart';

Future<http.Response?> registerEmail(SendEmailModel data) async {
  http.Response? response;
  try {
    response =
        await http.post(Uri.parse('$baseUrl/public/api/v2/user/register'),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode(data.toJson()));

    //   log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> verifyUserName(String name, String email) async {
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse(
          '$baseUrl/public/api/v2/checkUsername?username=$name&email=${email.trim()}'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    // log(response.body.toString());
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

    // log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.StreamedResponse?> verifyBusiness(
  RegisterBusinessModel data,
) async {
  http.StreamedResponse? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);

  final filePhotoName = basename(data.evidence!.path);
  // final filePhotoName1 = basename(data.photo!.path);

  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/user/verification"));
  Map<String, String> headers = {
    'Accept': 'application/json',
    'authorization': 'Bearer $token',
  };
  var filePhoto = await http.MultipartFile.fromPath(
      'evidence', data.evidence!.path,
      filename: filePhotoName);
  // var filePhoto1 = await http.MultipartFile.fromPath('photo', data.photo!.path,
  //     filename: filePhotoName1);

  request.headers.addAll(headers);
  // request.fields["name"] = data.name!.toString();
  request.fields["business_name"] = data.busName!.toString();
  request.fields["business_email"] = data.email!.toString();
  request.fields["phone"] = data.phone!.toString();
  request.fields["description"] = data.description!.toString();
  request.fields["is_registered"] = data.isReg!.toString();
  request.fields["country"] = data.country!.toString();
  request.fields["registration_no"] = data.regNo!.toString();
//  request.fields["address"] = data.address!.toString();
  // request.fields["id_type"] = data.idType!.toString();
//  request.fields["id_no"] = data.idNumb!.toString();
//  request.files.add(filePhoto1);
  request.files.add(filePhoto);
  request.fields["business_address"] = data.businessAddress!.toString();

  try {
    response = await request.send();
  } catch (e) {
    // log("hello");
    emitter(e.toString());
    response = null;
  }

  return response;
}

Future<http.StreamedResponse?> verifyUser(
  VerifyUserModel data,
) async {
  http.StreamedResponse? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);

  final filePhotoName = basename(data.photo!.path);
  List<dynamic> photo = [filePhotoName];

  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/user/verification"));
  Map<String, String> headers = {
    'Accept': 'application/json',
    'authorization': 'Bearer $token',
  };
  var filePhoto = await http.MultipartFile.fromPath('photo', data.photo!.path,
      filename: filePhotoName);

  request.headers.addAll(headers);
  request.fields["name"] = data.name!.toString();
  request.fields["id_type"] = data.idType!.toString();
  request.fields["id_no"] = data.idNumb!.toString();
  request.files.add(filePhoto);

  try {
    response = await request.send();
  } catch (e) {
    // log("hello");
    emitter(e.toString());
    response = null;
  }

  return response;
}

Future<http.StreamedResponse?> completeRegisteration(
  RegisterUserModel data,
) async {
  http.StreamedResponse? response;

//  final filePhotoName =
  var filePhoto;
//  List<dynamic> photo = [filePhotoName];

  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/user/register/complete"));
  Map<String, String> headers = {'Accept': 'application/json'};
  if (data.photo == null) {
  } else {
    filePhoto = await http.MultipartFile.fromPath('photo', data.photo!.path,
        filename: basename(data.photo!.path));
  }

  request.headers.addAll(headers);
  request.fields["email"] = data.email!;
  request.fields["gender_id"] = data.genderId!.toString();
  request.fields["dob"] = data.dob!.toString();
  request.fields["password"] = data.password!;
  request.fields["category_id"] = data.catId!;
  request.fields["country"] = data.country!.toString();
  request.fields["state"] = data.state!.toString();
  request.fields["city"] = data.city!.toString();
  request.fields["device"] = Platform.isIOS
      ? "IOS"
      : Platform.isAndroid
          ? "ANDROID"
          : Platform.isFuchsia
              ? "Fuchsia".toUpperCase()
              : "";
  if (data.photo != null) {
    request.files.add(filePhoto);
  }

  try {
    response = await request.send();
  } catch (e) {
    // log("hello");
    //  log(e.toString());
    response = null;
  }

  return response;
}
