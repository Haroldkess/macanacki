// To parse this JSON data, do
//
//     final profileFeedModel = profileFeedModelFromJson(jsonString);

import 'dart:convert';

ProfileFeedModel profileFeedModelFromJson(String str) =>
    ProfileFeedModel.fromJson(json.decode(str));

String profileFeedModelToJson(ProfileFeedModel data) =>
    json.encode(data.toJson());

class ProfileFeedModel {
  ProfileFeedModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<ProfileFeedDatum>? data;

  factory ProfileFeedModel.fromJson(Map<String, dynamic> json) =>
      ProfileFeedModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ProfileFeedDatum>.from(
                json["data"]!.map((x) => ProfileFeedDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ProfileFeedDatum {
  ProfileFeedDatum({
    this.id,
    this.description,
    this.published,
    this.createdAt,
    this.updatedAt,
    this.btnLink,
    this.creator,
    this.media,
    this.mux,
    this.vod,
    this.thumbnails,
    this.comments,
    this.noOfLikes,
    this.viewCount,
    this.button,
    this.user,
    this.promoted,
  });

  int? id;
  String? description;
  int? published;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? btnLink;
  String? creator;
  List<String>? media;
  List<String>? mux;
  List<dynamic>? vod;
  List<dynamic>? thumbnails;
  List<ProfileComment>? comments;
  int? noOfLikes;
  int? viewCount;
  String? button;
  ProfileUser? user;
  String? promoted;

  factory ProfileFeedDatum.fromJson(Map<String, dynamic> json) =>
      ProfileFeedDatum(
        id: json["id"],
        description: json["description"],
        published: json["published"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        btnLink: json["btn_link"],
        creator: json["creator"],
        media: json["media"] == null
            ? []
            : List<String>.from(json["media"]!.map((x) => x)),
        mux: json["mux"] == null
            ? []
            : List<String>.from(json["mux"]!.map((x) => x)),
        vod: json["vod"] == null
            ? []
            : List<dynamic>.from(json["vod"]!.map((x) => x)),
        thumbnails: json["thumbnails"] == null
            ? []
            : List<dynamic>.from(json["thumbnails"]!.map((x) => x)),
        comments: json["comments"] == null
            ? []
            : List<ProfileComment>.from(
                json["comments"]!.map((x) => ProfileComment.fromJson(x))),
        noOfLikes: json["no_of_likes"],
        viewCount: json["view_count"],
        button: json["button"],
        user: json["user"] == null ? null : ProfileUser.fromJson(json["user"]),
        promoted: json["promoted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "published": published,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "btn_link": btnLink,
        "creator": creator,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
        "mux": mux == null ? [] : List<dynamic>.from(mux!.map((x) => x)),
        "vod": vod == null ? [] : List<dynamic>.from(vod!.map((x) => x)),
        "thumbnails": thumbnails == null
            ? []
            : List<dynamic>.from(thumbnails!.map((x) => x)),
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "no_of_likes": noOfLikes,
        "view_count": viewCount,
        "button": button,
        "user": user?.toJson(),
        "promoted": promoted,
      };
}

class ProfileComment {
  ProfileComment({
    this.id,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.profilePhoto,
    this.noOfLikes,
    this.postId,
    this.isVerified,
  });

  int? id;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? username;
  String? profilePhoto;
  int? noOfLikes;
  int? postId;
  int? isVerified;

  factory ProfileComment.fromJson(Map<String, dynamic> json) => ProfileComment(
        id: json["id"],
        body: json["body"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        username: json["username"],
        profilePhoto: json["profile_photo"],
        noOfLikes: json["no_of_likes"],
        postId: json["post_id"],
        isVerified: json["user_verified"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "username": username,
        "profile_photo": profilePhoto,
        "no_of_likes": noOfLikes,
        "post_id": postId,
        "user_verified": isVerified
      };
}

class ProfileUser {
  ProfileUser({
    this.id,
    this.email,
    this.username,
    this.faceVerification,
    this.dob,
    this.emailVerified,
    this.registrationComplete,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.gender,
    this.verified,
    this.profilephoto,
    this.noOfFollowers,
    this.noOfFollowing,
  });

  int? id;
  String? email;
  String? username;
  int? faceVerification;
  String? dob;
  int? emailVerified;
  int? registrationComplete;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? gender;
  int? verified;
  String? profilephoto;
  int? noOfFollowers;
  int? noOfFollowing;

  factory ProfileUser.fromJson(Map<String, dynamic> json) => ProfileUser(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        faceVerification: json["face_verification"],
        dob: json["dob"],
        emailVerified: json["email_verified"],
        registrationComplete: json["registration_complete"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        gender: json["gender"],
        verified: json["verified"],
        profilephoto: json["profilephoto"],
        noOfFollowers: json["no_of_followers"],
        noOfFollowing: json["no_of_following"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "face_verification": faceVerification,
        "dob": dob,
        "email_verified": emailVerified,
        "registration_complete": registrationComplete,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "gender": gender,
        "verified": verified,
        "profilephoto": profilephoto,
        "no_of_followers": noOfFollowers,
        "no_of_following": noOfFollowing,
      };
}
