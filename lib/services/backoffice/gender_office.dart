import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:makanaki/services/api_url.dart';


Future<http.Response?> getGender() async {
  http.Response? response;
  try {
    response = await http.get(
        Uri.parse('$baseUrl/public/api/gender/list'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

 //   log(response.body.toString());
  } catch (e) {
    response = null;

  }
  return response;
}

