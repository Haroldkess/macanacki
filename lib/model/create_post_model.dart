import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

class CreatePostModel {
  String? description;
  int? published;
  File? media;

  CreatePostModel({
    this.description,
    this.published,
    this.media,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "description": description,
        "published": published,
        "media": await MultipartFile.fromPath('media', media!.path,
            filename: basename(media!.path)),
      };
}

class ShareCommentsModel {
  String? body;

  ShareCommentsModel({
    this.body,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "body": body,
      };
}
