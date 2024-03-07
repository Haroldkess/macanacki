import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/model/create_post_model.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import '../../presentation/widgets/debug_emitter.dart';

double getFileSize(File file) {
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / (1024 * 1024);
  return sizeInMb;
}

Future<http.StreamedResponse?> createPost(
  CreatePostModel data,
) async {
  emitter("Inside CreatePost Office");
  http.StreamedResponse? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  emitter(data.media!.first.path);
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
    emitter("FilePath Before Sending: ${data.media![i].path}");
    final xx = File(data.media![i].path);
    // emitter("AAAAAAAAAAAAAA");
    emitter(" FileSize before sending: ${getFileSize(xx).toString()}");
    // var f = await http.MultipartFile.fromPath(
    //   'media[$i]',
    //   data.media![i].path,
    // );
    // filePhoto.add(f);
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

Future<http.StreamedResponse?> createAudioPost(
  CreateAudioPostModel data,
) async {
  emitter("Inside CreateAudioPost Office");
  http.StreamedResponse? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  emitter(data.media!.first.path);
  // final filePhotoName = basename(data.media!.path);
  var request = http.MultipartRequest(
      "POST", Uri.parse("$baseUrl/public/api/v2/post/create"));
  Map<String, String> headers = {
    'Accept': 'application/json',
    'authorization': 'Bearer $token',
  };

  emitter(data.media!.first.path);
  // await Future.forEach(data.media!, (element) async {
  //   var f = await http.MultipartFile.fromPath('media', element.path,
  //       filename: basename(element.path));
  //   filePhoto.add(f);
  // });
  // var filePhoto = http.MultipartFile.fromBytes('media[0]',
  //     await File.fromUri(Uri(path: data.media!.first.path)).readAsBytes(),
  //     contentType: MediaType(
  //       'audio',
  //       'mp3',
  //     ));

  var filePhoto =
      await http.MultipartFile.fromPath('media[0]', data.media!.first.path,
          filename: "${basename(data.media!.first.path)}.mp3",
          contentType: MediaType(
            'audio',
            '.mp3',
          ));
  var fileCover = await http.MultipartFile.fromPath(
    'cover',
    data.cover!.path,
    filename: basename(data.cover!.path),
  );

  // var filePhoto = await http.MultipartFile.fromPath('media', data.media!.path,
  //     filename: filePhotoName);

  request.headers.addAll(headers);
  request.fields["description"] = data.description!;
  request.fields["published"] = data.published!.toString();
  request.fields["btn_id"] = data.btnId!.toString();
  request.fields["btn_link"] = data.url!.toString();
  request.files.add(filePhoto);
  request.files.add(fileCover);

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

    emitter(response.body.toString());
    emitter(response.statusCode.toString());
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
