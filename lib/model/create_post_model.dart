import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

class CreatePostModel {
  String? description;
  int? published;
  File? media;
  int? btnId;
  String? url;

  CreatePostModel({
    this.description,
    this.published,
    this.media,
    this.btnId,
    this.url,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "description": description,
        "published": published,
        "media": await MultipartFile.fromPath('media', media!.path,
            filename: basename(media!.path)),
        "btn_id": btnId,
        "btn_link": url,
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


class EditProfileModel {
  String? description;
  String? phone;
  String? media;


  EditProfileModel({
    this.description,
    this.phone,
    this.media,

  });

  Future<Map<String, dynamic>> toJson() async => {
        "about_me": description,
        "phone": phone,
        "selfie": media,
      
      };
}