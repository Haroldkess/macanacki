import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/services/api_url.dart';

import '../../presentation/widgets/debug_emitter.dart';

Future<http.Response?> loginUser(SendLoginModel data) async {
  http.Response? response;
  try {
    response = await http
        .post(Uri.parse('$baseUrl/public/api/user/login'),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode(data.toJson()))
        .timeout(const Duration(seconds: 30));

    emitter(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}
