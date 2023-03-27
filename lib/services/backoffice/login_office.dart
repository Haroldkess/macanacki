import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/services/api_url.dart';

Future<http.Response?> loginUser(SendLoginModel data) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse('$baseUrl/public/api/user/login'),
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