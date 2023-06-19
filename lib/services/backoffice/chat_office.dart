import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:makanaki/model/conversation_model.dart';
import 'package:makanaki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../temps/temps_id.dart';
import 'package:path/path.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

Future<http.StreamedResponse?> sendMessageTo(
  SendMsgModel data,
) async {
  http.StreamedResponse? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  var filePhoto;

  final filePhotoName = basename(data.media == null ? '' : data.media!.path);
  // List<dynamic> photo = [filePhotoName];

  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/chat/send/to/${data.username}"));
  Map<String, String> headers = {
    'Accept': 'application/json',
    'authorization': 'Bearer $token',
  };

  if (data.media != null) {
    filePhoto = await http.MultipartFile.fromPath('media', data.media!.path,
        filename: filePhotoName);
  }
  emitter("here is the body ${data.body}");
  request.headers.addAll(headers);
  request.fields["body"] = data.body!;
  if (data.media != null) {
    request.files.add(filePhoto);
  }

  try {
    response = await request.send().timeout(const Duration(seconds: 30));
  } catch (e) {
    //  log("hello");
    //  log(e.toString());
    response = null;
  }

  return response;
}

Future<http.Response?> getAllConversation() async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);

  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/chat/get/all'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getUnreadChat() async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);

  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/chat/unread/notifications'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
  } catch (e) {
    response = null;
  }
  return response;
}


Future<http.Response?> readAllChats(int userId) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);

  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/chat/markall/chats/$userId'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
  } catch (e) {
    response = null;
  }
  return response;
}