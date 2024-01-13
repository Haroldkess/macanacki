import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/model/create_post_model.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.StreamedResponse?> editProfile(
  EditProfileModel data,
) async {
  http.StreamedResponse? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  final filePhotoName = basename(data.media!);
  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/user/edit/profile"));
  Map<String, String> headers = {
    'Accept': 'application/json',
    'authorization': 'Bearer $token',
  };
  late var filePhoto;

  if (data.media!.isNotEmpty) {
    filePhoto = await http.MultipartFile.fromPath('profile', data.media!,
        filename: filePhotoName);
  }

  request.headers.addAll(headers);
  request.fields["about_me"] = data.description!;
  request.fields["phone"] = data.phone!.toString();
  request.fields["website"] = data.website!.toString();
  request.fields["country"] = data.country!;
  request.fields["state"] = data.state!.toString();
  request.fields["city"] = data.city!;

  if (data.media!.isNotEmpty) {
    request.files.add(filePhoto);
  }

  try {
    response = await request.send();
  } catch (e) {
    //   log("hello");
    //   log(e.toString());
    response = null;
  }

  return response;
}
