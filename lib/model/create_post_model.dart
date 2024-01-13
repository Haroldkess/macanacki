import 'dart:io';

class CreatePostModel {
  String? description;
  int? published;
  List<File>? media;
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
        "media": media,
        // "media": await MultipartFile.fromPath('media', media!.path,
        //     filename: basename(media!.path)),
        "btn_id": btnId,
        "btn_link": url,
      };
}

class CreateAudioPostModel {
  String? description;
  int? published;
  List<File>? media;
  int? btnId;
  String? url;
  File? cover;

  CreateAudioPostModel(
      {this.description,
      this.published,
      this.media,
      this.btnId,
      this.url,
      this.cover});

  Future<Map<String, dynamic>> toJson() async => {
        "description": description,
        "published": published,
        "media": media,
        // "media": await MultipartFile.fromPath('media', media!.path,
        //     filename: basename(media!.path)),
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
  String? website;
  String? country, state, city;

  EditProfileModel(
      {this.description,
      this.phone,
      this.media,
      this.country,
      this.state,
      this.city,
      this.website});

  Future<Map<String, dynamic>> toJson() async => {
        "about_me": description,
        "phone": phone,
        "selfie": media,
        "website": website
      };
}

class EditPost {
  String? body;

  EditPost({
    this.body,
  });
  Map<String, dynamic> toJson() {
    return {
      'description': body,
    };
  }
  // Future<Map<String, dynamic>> toJson() async => {
  //       "description": body,
  //     };
}
